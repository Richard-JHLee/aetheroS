# AetherOS

<p align="center">
  <img src="brand/logo.svg" alt="AetherOS Logo" width="200"/>
</p>

<h3 align="center">Invisible Intelligence, Everywhere</h3>

<p align="center">
  <strong>Intent-driven AI Operating System</strong><br>
  No Apps, Just Aether
</p>

<p align="center">
  <a href="#philosophy">Philosophy</a> •
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#roadmap">Roadmap</a> •
  <a href="#contributing">Contributing</a>
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

# Download models
python scripts/download_models.py

# Run AetherOS
python aether.py
```

### Manual Installation

```bash
# 1. Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 2. Install dependencies
pip install llama-cpp-python==0.2.20
pip install sentence-transformers==2.2.2
pip install watchdog==3.0.0

# 3. Download Phi-3.5-mini (INT4 quantized)
mkdir -p models
wget https://huggingface.co/microsoft/Phi-3.5-mini-instruct-gguf/resolve/main/Phi-3.5-mini-instruct-q4_0.gguf \
  -O models/phi-3.5-mini-q4.gguf

# 4. Initialize database
python scripts/init_db.py

# 5. Launch
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
"블루투스 켜줘"

# App launch
"Chrome 실행"
"VSCode로 이 프로젝트 열어줘"

# Information
"오늘 날씨 어때?"
"달러 환율 알려줘"
```

### Advanced Usage

```bash
# Pattern learning
"매일 아침 9시에 뉴스 요약 + 이메일 확인 자동화해줘"

# Code generation
"Python으로 CSV 파싱하는 스크립트 작성해줘"

# Complex tasks
"이번 주 회의록 모아서 요약 보고서 만들어줘"
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

자세한 아키텍처는 [ARCHITECTURE.md](docs/ARCHITECTURE.md)를 참조하세요.

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

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/aetherOS.git

# Create feature branch
git checkout -b feature/amazing-feature

# Make changes and commit
git commit -m "Add amazing feature"

# Push and create PR
git push origin feature/amazing-feature
```

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

## 📞 Contact

- **GitHub**: [@Richard-JHLee](https://github.com/Richard-JHLee)
- **Email**: [Your Email]
- **Discord**: [Community Server]

---

<p align="center">
  <strong>Think. Aether Does.</strong><br>
  Built with ❤️ by the AetherOS community
</p>

