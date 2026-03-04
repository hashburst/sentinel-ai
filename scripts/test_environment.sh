#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo "SentinelAI Environment Test"
echo "==========================="
for cmd_label in "docker:Docker" "python3:Python 3" "node:Node.js" "rustc:Rust"; do
    cmd="${cmd_label%%:*}"; label="${cmd_label##*:}"
    command -v "$cmd" &>/dev/null \
        && echo -e "${GREEN}✓ $label installed${NC}" \
        || echo -e "${RED}✗ $label not found${NC}"
done
command -v docker-compose &>/dev/null \
    && echo -e "${GREEN}✓ Docker Compose installed${NC}" \
    || echo -e "${YELLOW}⚠ Docker Compose not found (optional)${NC}"
echo "Testing Python packages..."
python3 -c "
packages = ['flask', 'requests', 'numpy']
for pkg in packages:
    try:
        __import__(pkg); print(f'  ✓ {pkg}')
    except ImportError:
        print(f'  ✗ {pkg} missing')
"
echo "Testing port availability..."
for port in 3000 8080 8081 5000 9090 3030; do
    lsof -i :"$port" &>/dev/null \
        && echo -e "${YELLOW}⚠ Port $port is in use${NC}" \
        || echo -e "${GREEN}✓ Port $port available${NC}"
done
[ -f /etc/rpi-issue ] && echo -e "${GREEN}✓ Running on Raspberry Pi${NC}"
echo -e "\nEnvironment test completed!"
