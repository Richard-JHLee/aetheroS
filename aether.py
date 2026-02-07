#!/usr/bin/env python3
"""
AetherOS - Invisible Intelligence, Everywhere
Version: 0.1.0 (Prototype)

A lightweight, intent-driven AI operating system.
No Apps, Just Aether.
"""

import os
import sys
import re
import json
import time
import sqlite3
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Any
import subprocess

# Optional dependencies (install if available)
try:
    from llama_cpp import Llama
    LLAMA_AVAILABLE = True
except ImportError:
    LLAMA_AVAILABLE = False
    print("⚠️  llama-cpp-python not installed. LLM features disabled.")
    print("   Install: pip install llama-cpp-python")


class AetherConfig:
    """AetherOS Configuration"""
    
    # Paths
    HOME_DIR = Path.home() / ".aetheros"
    DB_PATH = HOME_DIR / "aether.db"
    MODEL_DIR = HOME_DIR / "models"
    CACHE_DIR = HOME_DIR / "cache"
    
    # Model settings
    MODEL_PATH = MODEL_DIR / "phi-3.5-mini-q4.gguf"
    CONTEXT_LENGTH = 4096
    MAX_TOKENS = 256
    
    # Performance
    FAST_MATCHER_CONFIDENCE_THRESHOLD = 0.9
    CACHE_SIZE = 1000
    
    @classmethod
    def init_dirs(cls):
        """Initialize AetherOS directories"""
        cls.HOME_DIR.mkdir(exist_ok=True)
        cls.MODEL_DIR.mkdir(exist_ok=True)
        cls.CACHE_DIR.mkdir(exist_ok=True)


class Intent:
    """Parsed user intent"""
    
    def __init__(self, category: str, action: str, parameters: Dict[str, Any],
                 confidence: float, method: str):
        self.category = category
        self.action = action
        self.parameters = parameters
        self.confidence = confidence
        self.method = method
    
    def __repr__(self):
        return f"Intent({self.action}, confidence={self.confidence:.2f}, method={self.method})"


class VectorStore:
    """SQLite-based lightweight vector store"""
    
    def __init__(self, db_path: Path):
        self.db_path = db_path
        self.conn = sqlite3.connect(str(db_path))
        self.init_db()
    
    def init_db(self):
        """Initialize database schema"""
        cursor = self.conn.cursor()
        
        # File index with FTS5 full-text search
        cursor.execute("""
        CREATE VIRTUAL TABLE IF NOT EXISTS files 
        USING fts5(
            filepath,
            filename,
            content,
            filetype,
            created_date,
            modified_date,
            size,
            tokenize = 'porter unicode61'
        )
        """)
        
        # Command history
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS command_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            command TEXT NOT NULL,
            intent TEXT,
            result TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            execution_time REAL
        )
        """)
        
        # Context memory
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS context_memory (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT UNIQUE,
            value TEXT,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
        """)
        
        self.conn.commit()
    
    def search_files(self, query: str, filters: Optional[Dict] = None) -> List[Dict]:
        """Search files using FTS5"""
        cursor = self.conn.cursor()
        
        sql = "SELECT * FROM files WHERE files MATCH ?"
        params = [query]
        
        if filters:
            if 'filetype' in filters:
                sql += " AND filetype = ?"
                params.append(filters['filetype'])
        
        sql += " ORDER BY rank LIMIT 20"
        
        cursor.execute(sql, params)
        
        columns = [desc[0] for desc in cursor.description]
        results = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        return results
    
    def log_command(self, command: str, intent: str, result: str, exec_time: float):
        """Log command execution"""
        cursor = self.conn.cursor()
        cursor.execute("""
        INSERT INTO command_history (command, intent, result, execution_time)
        VALUES (?, ?, ?, ?)
        """, (command, intent, result, exec_time))
        self.conn.commit()


class FastMatcher:
    """Rule-based fast pattern matching (90% of cases)"""
    
    def __init__(self):
        self.patterns = self._load_patterns()
    
    def _load_patterns(self) -> Dict:
        """Load command patterns"""
        return {
            "file_search": {
                "patterns": [
                    r"(?P<time>어제|오늘|이번주)?\s*(?P<action>다운로드|생성|수정)한?\s*(?P<type>pdf|jpg|docx|txt|png)?\s*파일\s*(?P<verb>찾|검색)",
                    r"(?P<filename>.+)\s*(파일)?\s*(?P<action>열|삭제|복사)",
                ],
                "action": "search_files"
            },
            "system_control": {
                "patterns": [
                    r"볼륨\s*(?P<level>\d+)",
                    r"밝기\s*(?P<level>\d+)",
                    r"(?P<app>\w+)\s*(앱|프로그램)?\s*실행",
                ],
                "action": "system_control"
            }
        }
    
    def match(self, user_input: str) -> Intent:
        """Try to match input against patterns"""
        for category, config in self.patterns.items():
            for pattern in config['patterns']:
                match = re.search(pattern, user_input)
                
                if match:
                    params = match.groupdict()
                    return Intent(
                        category=category,
                        action=config['action'],
                        parameters=params,
                        confidence=0.95,
                        method="rule_based"
                    )
        
        # No match
        return Intent(
            category="unknown",
            action="unknown",
            parameters={},
            confidence=0.0,
            method="none"
        )


class LLMEngine:
    """Lightweight LLM engine using Phi-3.5"""
    
    def __init__(self):
        self.model = None
        self.model_loaded = False
        
        if not LLAMA_AVAILABLE:
            print("⚠️  LLM engine disabled (llama-cpp-python not installed)")
            return
        
        if not AetherConfig.MODEL_PATH.exists():
            print(f"⚠️  Model not found: {AetherConfig.MODEL_PATH}")
            print("   Download model using: python scripts/download_models.py")
            return
    
    def load_model(self):
        """Load model (lazy loading)"""
        if self.model_loaded or not LLAMA_AVAILABLE:
            return
        
        print("⚡ Loading AI model...")
        
        self.model = Llama(
            model_path=str(AetherConfig.MODEL_PATH),
            n_ctx=AetherConfig.CONTEXT_LENGTH,
            n_threads=os.cpu_count(),
            n_gpu_layers=0,  # CPU only (set to 35 for GPU)
            verbose=False
        )
        
        self.model_loaded = True
        print("✅ AI model ready")
    
    def parse_intent(self, user_input: str, context: Dict) -> Intent:
        """Parse user intent using LLM"""
        if not self.model_loaded:
            self.load_model()
        
        if not self.model:
            return Intent("error", "llm_unavailable", {}, 0.0, "error")
        
        prompt = f"""<|system|>
You are AetherOS intent parser. Parse user commands into JSON.
Be concise and accurate.<|end|>
<|user|>
Parse this command into JSON format:
Command: {user_input}
Context: {json.dumps(context, ensure_ascii=False)}

Response format (JSON only, no explanation):
{{
    "action": "search_files|system_control|app_launch|unknown",
    "parameters": {{}},
    "confidence": 0.0-1.0
}}
<|end|>
<|assistant|>
"""
        
        response = self.model(
            prompt,
            max_tokens=150,
            temperature=0.3,
            stop=["<|end|>", "<|user|>"],
            echo=False
        )
        
        text = response['choices'][0]['text'].strip()
        
        try:
            # Extract JSON from response
            json_match = re.search(r'\{.*\}', text, re.DOTALL)
            if json_match:
                parsed = json.loads(json_match.group())
                
                return Intent(
                    category=parsed.get('action', 'unknown'),
                    action=parsed.get('action', 'unknown'),
                    parameters=parsed.get('parameters', {}),
                    confidence=parsed.get('confidence', 0.5),
                    method="llm_based"
                )
        except Exception as e:
            print(f"❌ LLM parsing error: {e}")
        
        return Intent("error", "parse_failed", {}, 0.0, "llm_error")


class FileSearchHandler:
    """Handle file search operations"""
    
    def __init__(self, vector_store: VectorStore):
        self.store = vector_store
    
    def execute(self, params: Dict) -> Dict:
        """Execute file search"""
        time_filter = params.get('time')
        file_type = params.get('type', '*')
        
        # Build search query
        query_parts = []
        if file_type and file_type != '*':
            query_parts.append(file_type)
        
        query = ' '.join(query_parts) if query_parts else '*'
        
        # Search in database
        results = self.store.search_files(query)
        
        return {
            "status": "success",
            "count": len(results),
            "files": results[:5]  # Limit to 5 results
        }


class SystemControlHandler:
    """Handle system control operations"""
    
    def execute(self, params: Dict) -> Dict:
        """Execute system control command"""
        if 'level' in params:
            level = params['level']
            
            # Volume control
            try:
                subprocess.run(
                    ['amixer', 'set', 'Master', f'{level}%'],
                    check=True,
                    capture_output=True
                )
                return {
                    "status": "success",
                    "message": f"볼륨을 {level}%로 설정했습니다"
                }
            except subprocess.CalledProcessError:
                return {
                    "status": "error",
                    "message": "볼륨 조절 실패 (Linux only)"
                }
        
        elif 'app' in params:
            app = params['app']
            
            # App launch
            try:
                subprocess.Popen([app.lower()], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                return {
                    "status": "success",
                    "message": f"{app} 실행 중..."
                }
            except FileNotFoundError:
                return {
                    "status": "error",
                    "message": f"{app}을(를) 찾을 수 없습니다"
                }
        
        return {"status": "error", "message": "알 수 없는 명령"}


class AIOSCore:
    """AetherOS Core Engine"""
    
    def __init__(self):
        print("🌌 AetherOS v0.1.0 - Invisible Intelligence, Everywhere")
        print("=" * 60)
        
        # Initialize
        AetherConfig.init_dirs()
        
        self.vector_store = VectorStore(AetherConfig.DB_PATH)
        self.fast_matcher = FastMatcher()
        self.llm_engine = LLMEngine()
        
        # Handlers
        self.handlers = {
            "search_files": FileSearchHandler(self.vector_store),
            "system_control": SystemControlHandler()
        }
        
        print("✅ AetherOS initialized")
        print()
    
    def get_context(self) -> Dict:
        """Get current context"""
        return {
            "current_dir": os.getcwd(),
            "timestamp": datetime.now().isoformat(),
            "platform": sys.platform
        }
    
    def process(self, user_input: str) -> Dict:
        """Process user command"""
        start_time = time.time()
        
        # Get context
        context = self.get_context()
        
        # Fast matcher first
        intent = self.fast_matcher.match(user_input)
        
        # If fast matcher fails, use LLM
        if intent.confidence < AetherConfig.FAST_MATCHER_CONFIDENCE_THRESHOLD:
            print("🧠 Using AI for complex understanding...")
            intent = self.llm_engine.parse_intent(user_input, context)
        
        # Execute
        handler = self.handlers.get(intent.action)
        
        if handler:
            result = handler.execute(intent.parameters)
        else:
            result = {
                "status": "error",
                "message": f"'{user_input}' 명령을 이해하지 못했습니다"
            }
        
        exec_time = time.time() - start_time
        
        # Log
        self.vector_store.log_command(
            user_input,
            str(intent),
            json.dumps(result, ensure_ascii=False),
            exec_time
        )
        
        return {
            "intent": intent,
            "result": result,
            "execution_time": exec_time
        }
    
    def format_response(self, result: Dict) -> str:
        """Format result for display"""
        if result['result']['status'] == 'success':
            msg = result['result'].get('message')
            
            if msg:
                return f"✅ {msg}"
            
            # File search results
            files = result['result'].get('files', [])
            if files:
                response = f"📁 {result['result']['count']}개의 파일을 찾았습니다:\n"
                for i, file in enumerate(files[:5], 1):
                    response += f"  {i}. {file.get('filename', 'Unknown')}\n"
                return response
            
            return "✅ 완료"
        else:
            return f"❌ {result['result'].get('message', '오류 발생')}"


def main():
    """Main entry point"""
    
    # Initialize AetherOS
    aios = AIOSCore()
    
    print("💡 Tip: Type 'help' for examples, 'exit' to quit")
    print()
    
    # REPL loop
    while True:
        try:
            # Get user input
            user_input = input("🌌 aether> ").strip()
            
            if not user_input:
                continue
            
            # Special commands
            if user_input.lower() in ['exit', 'quit', 'q']:
                print("👋 Goodbye!")
                break
            
            if user_input.lower() == 'help':
                print("""
AetherOS Examples:
  
  파일 관리:
    - 어제 다운로드한 PDF 파일 찾아줘
    - report.pdf 파일 열어줘
  
  시스템 제어:
    - 볼륨 50
    - 밝기 70
    - Chrome 실행
  
  기타:
    - help    도움말
    - exit    종료
                """)
                continue
            
            # Process command
            result = aios.process(user_input)
            
            # Display result
            response = aios.format_response(result)
            print(response)
            
            # Show execution time
            print(f"⏱️  {result['execution_time']:.3f}s ({result['intent'].method})")
            print()
            
        except KeyboardInterrupt:
            print("\n👋 Goodbye!")
            break
        except Exception as e:
            print(f"❌ Error: {e}")


if __name__ == "__main__":
    main()
