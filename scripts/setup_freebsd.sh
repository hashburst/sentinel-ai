#!/bin/bash
set -e
echo "SentinelAI FreeBSD Setup"
pkg install -y git python3 node npm rust docker
sysrc docker_enable="YES" && service docker start
python3 -m venv venv && source venv/bin/activate
pip install --upgrade pip && pip install -r backend/requirements.txt
command -v pnpm &>/dev/null || npm install -g pnpm
cd frontend && pnpm install && cd ..
git submodule update --init --recursive
echo 'pf_enable="YES"' >> /etc/rc.conf
cat >> /etc/pf.conf << 'EOF'
rdr pass on $ext_if inet proto tcp from any to any port 80 -> 127.0.0.1 port 8081
rdr pass on $ext_if inet proto tcp from any to any port 443 -> 127.0.0.1 port 8443
EOF
service pf start
echo "FreeBSD setup completed!"
