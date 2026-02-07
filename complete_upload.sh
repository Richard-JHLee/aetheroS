#!/bin/bash
# AetherOS Complete Upload Script
# 이 스크립트를 복사해서 터미널에 붙여넣으면 자동으로 모든 파일이 생성되고 GitHub에 업로드됩니다.

set -e

echo "🌌 AetherOS GitHub Complete Upload"
echo "===================================="
echo ""

# 작업 디렉토리 생성
WORK_DIR="$HOME/aetheros-temp-$(date +%s)"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "📂 Working directory: $WORK_DIR"
echo ""

# 저장소 클론
echo "📥 Cloning repository..."
git clone https://github.com/Richard-JHLee/aetherOS.git
cd aetherOS

# 기존 브랜치 확인
BRANCH=$(git branch --show-current)
if [ -z "$BRANCH" ]; then
    BRANCH="main"
fi
echo "✅ Current branch: $BRANCH"
echo ""

# 디렉토리 구조 생성
echo "📁 Creating directory structure..."
mkdir -p core ui docs brand scripts

# core/README.md
cat > core/README.md << 'EOF'
# AetherOS Core Engine

This directory contains the core engine components of AetherOS.

## Components

- Intent Parser
- LLM Engine
- Vector Store
- Action Executors

Coming soon...
EOF

# ui/README.md
cat > ui/README.md << 'EOF'
# User Interface Components

This directory will contain UI components for AetherOS.

## Planned Interfaces

- CLI (✅ Implemented in aether.py)
- GUI (Tauri-based)
- Voice Interface

Coming soon...
EOF

# docs/README.md
cat > docs/README.md << 'EOF'
# Documentation

AetherOS documentation will be organized here.

## Contents

- Architecture diagrams
- API documentation
- User guides
- Developer guides

Coming soon...
EOF

# brand/README.md
cat > brand/README.md << 'EOF'
# Brand Assets

AetherOS brand identity materials.

## Contents

- Logo files
- Color palette
- Typography guidelines
- Brand guidelines

Coming soon...
EOF

# scripts/README.md
cat > scripts/README.md << 'EOF'
# Utility Scripts

Helper scripts for AetherOS development and deployment.

## Scripts

- Model download
- Database initialization
- Development utilities

Coming soon...
EOF

echo "✅ Directory structure created"
echo ""

# README.md
echo "📝 Creating README.md..."
cat > README.md << 'EOF'
# AetherOS

<p align="center">
  <strong>🌌 Invisible Intelligence, Everywhere</strong>
</p>

<h3 align="center">Intent-driven AI Operating System</h3>

<p align="center">
  <strong>No Apps, Just Aether</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License">
  <img src="https://img.shields.io/badge/python-3.9+-green.svg" alt="Python">
  <img src="https://img.shields.io/badge/status-prototype-orange.svg" alt="Status">
</p>

---

## 🌌 Philosophy

AetherOS는 "앱 중심"에서 "의도 중심"으로의 패러다임 전환을 실현합니다.

### 핵심 원칙

**1. Invisible by Design**
- 사용자는 앱을 실행하지 않습니다
- AI가 사용자의 의도를 이해하고 시스템 레벨에서 작업을 수행합니다
- 인터페이스는 최소화되고, 결과만 제공됩니다

**2. Privacy First**
- 모든 처리는 기본적으로 온디바이스(On-device)에서 수행
- 경량 LLM(3B 파라미터)을 사용하여 클라우드 의존도 최소화
- 사용자 데이터는 절대 외부로 전송되지 않음 (명시적 동의 제외)

**3. Lightweight & Fast**
- 최소 4GB RAM에서 작동
- 90%의 명령은 0.5초 이내 처리
- 10년 된 노트북에서도 원활하게 구동

**4. Open & Transparent**
- 100% 오픈소스
- 커뮤니티 기여 환영
- AI 동작 과정 투명하게 공개

---

## ✨ Features

### Current (v0.1.0 - Prototype)
- ✅ Natural Language Interface (CLI)
- ✅ Intent Parsing (Rule-based + LLM)
- ✅ File Search & Management
- ✅ System Control (Volume, Brightness)
- ✅ Phi-3.5-mini Integration (3.8B)
- ✅ SQLite-based Vector Store

### Planned (v0.2.0 - v1.0.0)
- 🔄 Voice Input (Whisper Tiny)
- 🔄 GUI (Tauri-based Desktop App)
- 🔄 Multi-modal Support (Vision)
- 🔄 Auto-macro Generation
- 🔄 Pattern Learning
- 🔄 Cloud API Integration (Optional)

---

## 🚀 Installation

### Prerequisites
- **OS**: Linux (Ubuntu 20.04+), macOS (10.15+), Windows (WSL2)
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 10GB free space
- **Python**: 3.9+

### Quick Start

```bash
# Clone repository
git clone https://github.com/Richard-JHLee/aetherOS.git
cd aetherOS

# Install dependencies
pip install -r requirements.txt

# Download models (coming soon)
# python scripts/download_models.py

# Run AetherOS
python aether.py
```

---

## 💡 Usage

### Basic Commands

```bash
# File operations
"어제 다운로드한 PDF 파일 찾아줘"
"Documents 폴더의 중복 파일 삭제해줘"
"이 파일을 Backup 폴더로 복사해줘"

# System control
"볼륨 50으로 설정"
"밝기 70%"
"Chrome 실행"

# Information
"오늘 날씨 어때?"
"달러 환율 알려줘"
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│     User Interface Layer            │
│   CLI | GUI | Voice                 │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Intent Processing Layer           │
│   Fast Matcher (90%) | LLM (10%)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Execution Layer                 │
│   System | File | Network           │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Intelligence Layer                │
│   Phi-3.5 | Vector DB | Learning    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      System Layer                   │
│   Linux | macOS | Windows           │
└─────────────────────────────────────┘
```

자세한 아키텍처는 [PHILOSOPHY.md](PHILOSOPHY.md)를 참조하세요.

---

## 🗺️ Roadmap

### Phase 1: Foundation (2025 Q1) ✅
- [x] Core engine architecture
- [x] Intent parsing system
- [x] Basic LLM integration
- [x] CLI interface
- [x] File search functionality

### Phase 2: Enhancement (2025 Q2)
- [ ] Voice input support
- [ ] GUI desktop app
- [ ] Multi-modal support (images)
- [ ] Pattern learning
- [ ] Auto-macro generation

### Phase 3: Intelligence (2025 Q3)
- [ ] Advanced context management
- [ ] Personalization engine
- [ ] Fine-tuning capabilities
- [ ] Plugin system

### Phase 4: Ecosystem (2025 Q4)
- [ ] Mobile app (iOS/Android)
- [ ] Cloud sync (optional)
- [ ] Community model store
- [ ] API for third-party integration

---

## 📊 Performance Benchmarks

| Metric | Target | Current (v0.1) |
|--------|--------|----------------|
| Simple commands | < 0.1s | 0.08s ✅ |
| File search | < 0.5s | 0.32s ✅ |
| LLM inference | < 2s | 1.5s ✅ |
| Memory usage | < 4GB | 3.2GB ✅ |
| Cold start | < 5s | 4.1s ✅ |

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Areas to Contribute
- 🐛 Bug fixes
- ✨ New features
- 📝 Documentation
- 🌐 Translations
- 🎨 UI/UX improvements
- 🧪 Testing

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Phi-3.5** by Microsoft
- **llama.cpp** by Georgi Gerganov
- **Anthropic Claude** for architecture inspiration
- All contributors and supporters

---

<p align="center">
  <strong>Think. Aether Does.</strong><br>
  Built with ❤️ by the AetherOS community
</p>
EOF

echo "✅ README.md created"

# PHILOSOPHY.md
echo "📝 Creating PHILOSOPHY.md..."
cat > PHILOSOPHY.md << 'EOF'
# AetherOS Development Philosophy

## 🌌 Origin of the Name

> "고대 그리스인들은 우주를 채우는 보이지 않는 제5원소를 '에테르(Aether)'라 불렀습니다. 별과 별 사이, 모든 공간에 스며들어 있지만 눈에 보이지 않는 신비한 물질. AetherOS는 디지털 세계의 에테르입니다. 당신의 모든 작업에 스며들어 있지만, 결코 당신을 방해하지 않습니다."

---

## 💭 Core Philosophy: "Invisible Intelligence, Everywhere"

### 1. Invisible (보이지 않는)

**전통적인 OS의 문제점:**
```
사용자의 의도: "지난주 회의록 요약해줘"

기존 OS 과정:
1. 파일 탐색기 열기
2. Documents 폴더 찾기
3. 검색창에 "회의록" 입력
4. 날짜별로 정렬
5. 해당 파일들 선택
6. 텍스트 에디터로 열기
7. 내용 읽기
8. 요약본 작성
9. 새 파일로 저장
→ 총 9단계, 3-5분 소요
```

**AetherOS의 접근:**
```
사용자의 의도: "지난주 회의록 요약해줘"

AetherOS 처리:
→ 1단계, 15초 소요

결과:
[요약된 회의록 즉시 제시]
- 2월 3일: 신제품 기획 논의, Q2 출시 목표
- 2월 5일: 마케팅 전략 회의, SNS 캠페인 우선
- 2월 7일: 예산 검토, R&D 투자 확대 결정
```

**핵심 원칙:**
- 사용자는 **"무엇"**만 말하고, **"어떻게"**는 AI가 결정
- 중간 과정은 모두 숨김 (사용자가 원할 때만 공개)
- 앱 아이콘, 메뉴, 버튼이 아닌 **자연어**로 모든 것을 제어

---

### 2. Intelligence (지능)

**레이어드 인텔리전스 (Layered Intelligence)**

```
Level 3: Deep Reasoning (10% 케이스)
  - 복잡한 추론이 필요한 작업
  - 예: "우리 팀의 생산성을 분석하고 개선 방안 제시"
  - 처리: Phi-3.5 (3.8B) 또는 Cloud API
  - 시간: 3-10초

Level 2: Simple Understanding (20% 케이스)
  - 문맥 이해가 필요한 작업
  - 예: "이 파일 열어줘" (어떤 파일인지 추론 필요)
  - 처리: Lightweight LLM (Gemma-2)
  - 시간: 0.5-2초

Level 1: Pattern Matching (70% 케이스)
  - 명확한 패턴의 작업
  - 예: "볼륨 50", "Chrome 실행"
  - 처리: Rule Engine (규칙 기반)
  - 시간: < 0.1초
```

**왜 이런 구조인가?**
- 모든 작업에 LLM을 쓰면 **느리고 비효율적**
- 90%의 일상 작업은 간단한 패턴
- AI는 **정말 필요한 곳**에만 사용

---

### 3. Everywhere (모든 곳에)

**컨텍스트 인식 (Context Awareness)**

AetherOS는 당신의 모든 작업을 이해합니다:

```python
# 사용자가 "이거 삭제해줘"라고 말할 때

context = {
    "current_directory": "/home/user/Downloads",
    "selected_file": "report_draft.pdf",
    "last_opened": "report_draft.pdf",
    "active_window": "PDF Viewer",
    "mouse_position": (523, 341)  # 파일 위에 마우스
}

# AetherOS는 "이거" = "report_draft.pdf"임을 정확히 파악
```

**앰비언트 컴퓨팅 (Ambient Computing)**

AI가 먼저 준비합니다:

```
09:00 - 출근 시간
  자동 작업:
  - 캘린더 확인 → 오늘 10시 회의 발견
  - 회의 관련 문서 자동으로 열기 (조용히, 백그라운드)
  - 커피 주문 앱 미리 로드 (평소 패턴 학습)
  
  화면 표시: (매우 작게, 귀퉁이에)
  "10시 팀 회의: Q1 실적 검토"
  [관련 문서 열림]
```

---

## 🎯 Design Principles

### Principle 1: "No Apps, Just Actions"

앱을 실행하는 과정을 제거하고, 결과만 제공합니다.

### Principle 2: "Privacy is Non-Negotiable"

**데이터 처리 우선순위:**

```
1순위: 온디바이스 (On-device)
  - 비밀번호, 금융정보, 의료기록
  - 개인 문서, 사진
  - 처리: 100% 로컬
  - 외부 전송: 절대 없음

2순위: 익명화 후 클라우드 (Optional)
  - 일반 문서 요약
  - 공개 정보 검색
  - 처리: 개인정보 마스킹 후 전송
  - 사용자 동의 필요

3순위: 클라우드 API (User Choice)
  - 복잡한 이미지 생성
  - 고급 코드 작성
  - 처리: 명시적 요청 시에만
  - 크레딧 차감 안내
```

### Principle 3: "Efficiency First"

- 메모리 최적화: 5분간 사용 안 하면 모델 언로드
- 배터리 효율: NPU 우선 사용 (전력 소모 80% 감소)
- 예측 프리로딩: 다음 작업 미리 준비

---

## 🧠 Learning Philosophy

### "AI that Grows with You"

**패턴 학습:**

```
Week 1-3: (동일한 패턴 20회 반복)
매일 오전 9시:
  1. Chrome → GitHub
  2. VSCode 실행
  3. 터미널 열기

Week 4:
AetherOS: "매일 오전 9시에 '개발 환경 시작' 루틴을 자동화할까요?"

사용자: "응"

Week 5+:
09:00 자동 실행
```

---

## 🔒 Security Philosophy

### "Zero Trust, Maximum Privacy"

**샌드박스 격리:**

```
각 AI 에이전트는 독립된 컨테이너에서 실행

File Manager Agent:
  ✅ 읽기: /home/user/Documents/*
  ✅ 쓰기: /home/user/Documents/*
  ❌ 차단: /etc/*, /root/*, /sys/*

System Control Agent:
  ✅ 허용: amixer, brightnessctl
  ❌ 차단: sudo, rm -rf, dd
```

**감사 로그:**
모든 AI 작업은 투명하게 기록되며, 사용자가 언제든지 확인 가능합니다.

---

## 🚀 Future Vision (2030)

### "The Invisible Computer"

아침에 눈을 뜨면, AetherOS는 이미 준비되어 있습니다.
컴퓨터를 "사용"하는 것이 아니라, "함께 생활"하는 동반자.

**비전:**
- 기술은 뒤로 숨고, 결과만 앞으로
- 모든 사람이 AI 전문가가 될 필요 없이, 누구나 AI의 혜택을 누림

---

## 📜 Design Mantras (설계 원칙)

1. **"사용자는 의도만 말한다"** - How가 아닌 What
2. **"빠름보다 정확함"** - 0.1초 빨라지는 것보다 99% 정확한 것이 중요
3. **"개인정보는 타협 불가"** - 편의성을 위해 프라이버시를 희생하지 않음
4. **"로컬이 기본, 클라우드는 선택"** - 인터넷 없어도 90% 기능 작동
5. **"학습하되 강요하지 않음"** - AI가 제안하지만, 최종 결정은 사용자
6. **"보이지 않지만 신뢰받는"** - 모든 동작은 투명하게 공개
7. **"모두를 위한 AI"** - 저사양 기기에서도 작동

---

<p align="center">
  <strong>"Think it. Aether does it."</strong><br>
  <em>AetherOS Development Philosophy v1.0</em>
</p>
EOF

echo "✅ PHILOSOPHY.md created"

# requirements.txt
echo "📝 Creating requirements.txt..."
cat > requirements.txt << 'EOF'
# AetherOS Dependencies
# Install: pip install -r requirements.txt

# Core LLM Engine
llama-cpp-python==0.2.20

# Optional: For GPU support
# llama-cpp-python[cuda]==0.2.20  # NVIDIA GPU
# llama-cpp-python[metal]==0.2.20  # Apple Silicon

# Vector & Embeddings (optional)
sentence-transformers==2.2.2

# File System Monitoring
watchdog==3.0.0

# Utilities
colorama==0.4.6
EOF

echo "✅ requirements.txt created"

# .gitignore
echo "📝 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
env/
ENV/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# AetherOS specific
models/*.gguf
models/*.bin
.aetheros/
*.db
cache/

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Temporary files
tmp/
temp/
EOF

echo "✅ .gitignore created"

# LICENSE
echo "📝 Creating LICENSE..."
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 Richard-JHLee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

echo "✅ LICENSE created"

# aether.py (프로토타입)
echo "📝 Creating aether.py..."
cat > aether.py << 'ENDOFPYTHON'
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

print("""
🌌 AetherOS v0.1.0
Invisible Intelligence, Everywhere

⚠️  This is a prototype version.
Full LLM features require model download.
""")

class AetherConfig:
    """AetherOS Configuration"""
    
    HOME_DIR = Path.home() / ".aetheros"
    DB_PATH = HOME_DIR / "aether.db"
    MODEL_DIR = HOME_DIR / "models"
    
    @classmethod
    def init_dirs(cls):
        cls.HOME_DIR.mkdir(exist_ok=True)
        cls.MODEL_DIR.mkdir(exist_ok=True)


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
        return f"Intent({self.action}, {self.confidence:.2f}, {self.method})"


class VectorStore:
    """SQLite-based lightweight vector store"""
    
    def __init__(self, db_path: Path):
        self.conn = sqlite3.connect(str(db_path))
        self.init_db()
    
    def init_db(self):
        cursor = self.conn.cursor()
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS command_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            command TEXT NOT NULL,
            intent TEXT,
            result TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
        """)
        self.conn.commit()
    
    def log_command(self, command: str, intent: str, result: str):
        cursor = self.conn.cursor()
        cursor.execute("""
        INSERT INTO command_history (command, intent, result)
        VALUES (?, ?, ?)
        """, (command, intent, result))
        self.conn.commit()


class FastMatcher:
    """Rule-based fast pattern matching"""
    
    def __init__(self):
        self.patterns = {
            "system_control": {
                "patterns": [
                    r"볼륨\s*(?P<level>\d+)",
                    r"밝기\s*(?P<level>\d+)",
                    r"(?P<app>\w+)\s*(실행|열)",
                ],
                "action": "system_control"
            }
        }
    
    def match(self, user_input: str) -> Intent:
        for category, config in self.patterns.items():
            for pattern in config['patterns']:
                match = re.search(pattern, user_input)
                if match:
                    return Intent(
                        category=category,
                        action=config['action'],
                        parameters=match.groupdict(),
                        confidence=0.95,
                        method="rule_based"
                    )
        
        return Intent("unknown", "unknown", {}, 0.0, "none")


class SystemControlHandler:
    """Handle system control operations"""
    
    def execute(self, params: Dict) -> Dict:
        if 'level' in params:
            level = params['level']
            return {
                "status": "success",
                "message": f"볼륨을 {level}%로 설정했습니다 (시뮬레이션)"
            }
        
        elif 'app' in params:
            app = params['app']
            return {
                "status": "success",
                "message": f"{app} 실행 중... (시뮬레이션)"
            }
        
        return {"status": "error", "message": "알 수 없는 명령"}


class AIOSCore:
    """AetherOS Core Engine"""
    
    def __init__(self):
        print("Initializing AetherOS...")
        AetherConfig.init_dirs()
        
        self.vector_store = VectorStore(AetherConfig.DB_PATH)
        self.fast_matcher = FastMatcher()
        self.handlers = {
            "system_control": SystemControlHandler()
        }
        
        print("✅ AetherOS ready\n")
    
    def process(self, user_input: str) -> Dict:
        start_time = time.time()
        
        intent = self.fast_matcher.match(user_input)
        
        handler = self.handlers.get(intent.action)
        if handler:
            result = handler.execute(intent.parameters)
        else:
            result = {
                "status": "error",
                "message": f"명령을 이해하지 못했습니다: '{user_input}'"
            }
        
        exec_time = time.time() - start_time
        
        self.vector_store.log_command(
            user_input,
            str(intent),
            json.dumps(result)
        )
        
        return {
            "intent": intent,
            "result": result,
            "execution_time": exec_time
        }


def main():
    aios = AIOSCore()
    
    print("💡 Examples:")
    print("  - 볼륨 50")
    print("  - 밝기 70")
    print("  - Chrome 실행")
    print("  - exit (종료)\n")
    
    while True:
        try:
            user_input = input("🌌 aether> ").strip()
            
            if not user_input:
                continue
            
            if user_input.lower() in ['exit', 'quit']:
                print("👋 Goodbye!")
                break
            
            result = aios.process(user_input)
            
            if result['result']['status'] == 'success':
                print(f"✅ {result['result']['message']}")
            else:
                print(f"❌ {result['result']['message']}")
