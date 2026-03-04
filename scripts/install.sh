#!/bin/bash
# SentinelAI Installer - Multi-OS Support
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${GREEN}========================================"
echo -e "   SentinelAI Installer v1.0"
echo -e "========================================${NC}"

OS="auto"; TYPE="full"
while [[ $# -gt 0 ]]; do
    case $1 in
        --os) OS="$2"; shift 2 ;;
        --type) TYPE="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then . /etc/os-release; OS=$ID; fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then OS="macos"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then OS="freebsd"
    else echo -e "${RED}Unsupported OS${NC}"; exit 1; fi
}

[[ "$OS" == "auto" ]] && detect_os
echo -e "${GREEN}Detected OS: $OS${NC}"

install_deps() {
    echo -e "${YELLOW}Installing dependencies...${NC}"
    case $OS in
        debian|ubuntu|raspbian)
            sudo apt-get update
            sudo apt-get install -y git curl wget python3 python3-pip nodejs npm \
                docker.io docker-compose build-essential
            sudo systemctl enable docker && sudo systemctl start docker
            sudo usermod -aG docker "$USER"
            ;;
        rhel|centos|fedora)
            sudo dnf install -y epel-release
            sudo dnf install -y git curl wget python3 python3-pip nodejs npm docker docker-compose
            sudo systemctl enable docker && sudo systemctl start docker
            sudo usermod -aG docker "$USER"
            ;;
        freebsd)
            pkg install -y git python3 node npm docker
            sysrc docker_enable="YES" && service docker start
            ;;
        macos)
            command -v brew &>/dev/null || \
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            brew install git python@3.11 node rust docker docker-compose colima
            colima start --cpu 4 --memory 8
            ;;
        windows)
            echo "Please use install.ps1 for Windows"; exit 0 ;;
        *) echo -e "${RED}Unsupported OS: $OS${NC}"; exit 1 ;;
    esac
}

setup_python() {
    echo -e "${YELLOW}Setting up Python virtual environment...${NC}"
    python3 -m venv venv && source venv/bin/activate
    pip install --upgrade pip
    pip install -r backend/requirements.txt
}

setup_node() {
    echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
    command -v pnpm &>/dev/null || npm install -g pnpm
    cd frontend && pnpm install && cd ..
}

init_submodules() {
    echo -e "${YELLOW}Initializing submodules...${NC}"
    git submodule update --init --recursive
}

download_models() {
    echo -e "${YELLOW}Downloading AI models...${NC}"
    mkdir -p models
    if [ -d "modules/deepfake" ]; then
        cd modules/deepfake && python3 download_models.py --all || true && cd ../..
    fi
}

configure_raspbian() {
    if [[ "$OS" == "raspbian" ]]; then
        echo -e "${YELLOW}Applying Raspbian optimizations...${NC}"
        echo "export NODE_OPTIONS=--max_old_space_size=512" >> ~/.bashrc
        sed -i 's/model: "llama3.1:8b"/model: "tinyllama:1.1b"/' \
            config/honeypot/galah_config.yaml 2>/dev/null || true
        export DEEPFAKE_USE_GPU=false
    fi
}

main() {
    install_deps && setup_python && setup_node
    init_submodules && download_models && configure_raspbian
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Installation completed! Start with:${NC}"
    echo -e "${GREEN}  make run   OR   make docker-dev${NC}"
    echo -e "${GREEN}========================================${NC}"
    case $OS in
        debian|ubuntu|raspbian|rhel)
            echo -e "${YELLOW}Note: log out and back in for docker group changes.${NC}" ;;
    esac
}

main
