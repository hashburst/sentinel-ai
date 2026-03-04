#!/bin/bash
set -e
echo "SentinelAI macOS Setup"
command -v brew &>/dev/null || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git python@3.11 node rust docker docker-compose colima
colima stop 2>/dev/null || true
colima start --cpu 4 --memory 8 --disk 50
[[ $(uname -m) == "arm64" ]] && export DOCKER_DEFAULT_PLATFORM=linux/arm64
python3 -m venv venv && source venv/bin/activate
pip install --upgrade pip && pip install -r backend/requirements.txt
command -v pnpm &>/dev/null || npm install -g pnpm
cd frontend && pnpm install && cd ..
git submodule update --init --recursive
[ -d "modules/deepfake" ] && { cd modules/deepfake && python3 download_models.py --all || true && cd ../..;}
echo "macOS setup completed! Start with: make run"
