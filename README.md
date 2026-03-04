# SentinelAI - Unified Cyber Intelligence & Defense Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust](https://img.shields.io/badge/Rust-1.70%2B-orange)](https://www.rust-lang.org/)
[![Python](https://img.shields.io/badge/Python-3.9%2B-blue)](https://python.org)
[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)](https://docker.com)

**SentinelAI** is an open-source platform extending [WorldMonitor](https://github.com/koala73/worldmonitor) with advanced cyber intelligence capabilities, AI defense/offense mechanisms, intelligent honeypots, and threat analysis. Designed for SOC teams, red team operations, and security researchers.

## Key Features

- **Global Monitoring**: 40+ geospatial layers on interactive 3D globe
- **AI-Powered Defense**: Protection against prompt injection and cognitive attacks
- **Intelligent Honeypots**: Dynamic trap generation with local LLMs
- **Deepfake Detection**: Image/video analysis with Vision Transformer
- **Red Team Automation**: Supply chain attack simulation (Singularity)
- **Fork Bomb Protection**: Detection and mitigation of resource exhaustion
- **Signed URL Security**: HMAC-SHA256 with time-based expiration
- **Unified Dashboard**: Real-time attack visualization
- **Local LLM**: Privacy-preserving with Ollama/LM Studio
- **EDR/XDR APIs**: Integration with Carbon Black, Microsoft 365 Defender, BitCorp XDR
- **TEP Protocol**: Telecommunications protocol for IoT, Drone, Satellite communication

## Supported Operating Systems

| OS Family | Tested Versions | Architecture | Container Support |
|-----------|-----------------|--------------|-------------------|
| **FreeBSD/pfSense** | 13.2, 14.0 | amd64, arm64 | Podman/Docker (partial) |
| **RHEL** | 8.8, 9.2 | x86_64, aarch64 | Docker/Podman |
| **Debian/Ubuntu** | 11, 12, 22.04, 24.04 | amd64, arm64 | Docker full |
| **Raspbian** | 11, 12 | armv7l, aarch64 | Docker (optimized) |
| **macOS** | Ventura, Sonoma | Intel, Apple Silicon | Docker Desktop/Colima |
| **Windows** | 10, 11, Server 2022 | x64 | Docker Desktop/WSL2 |

## Quick Installation

### Prerequisites (All Systems)
```bash
# Required:
# Git, Docker 20.10+, 8GB RAM min (16GB recommended)
# 20GB disk space, Python 3.9+, Node.js 18+, Rust 1.70+
```

### Debian/Ubuntu/Raspbian
```bash
git clone https://github.com/hashburst/sentinel-ai.git
cd sentinel-ai
sudo ./scripts/install.sh --os debian --type full
./scripts/test_environment.sh
```

### RHEL
```bash
sudo ./scripts/install.sh --os rhel --type minimal
```

### FreeBSD
```bash
./scripts/install.sh --os freebsd --type core
```

### macOS
```bash
./scripts/setup_macos.sh
make dev
```

### Windows (PowerShell Admin)
```powershell
.\scripts\install.ps1 -Environment production
```

## Docker Compose (Unified Environment)

```bash
docker-compose up --build
```

Access dashboard at: `http://localhost:3000`  
Default credentials: `admin` / `changeme`

## Documentation

- [System Architecture](docs/ARCHITECTURE.md)
- [API Reference](docs/API_REFERENCE.md)
- [Threat Models](docs/THREAT_MODELS.md)
- [Contributing Guide](docs/CONTRIBUTING.md)

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contact

- **Issues**: BitCorp
- **Security**: g.pegoraro@bitcorp.it
- **Community**: BitCorp (github.com/GioPat)
