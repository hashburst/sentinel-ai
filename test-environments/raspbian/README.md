# Raspbian Test Environment for SentinelAI

## Supported Models
- Raspberry Pi 3B, 3B+, 4B (2GB/4GB/8GB), 400, 5

## Installation
```bash
git clone https://github.com/hashburst/sentinel-ai.git
cd sentinel-ai
sudo ./scripts/install.sh --os raspbian --type lite
```

## Optimizations
- Reduced Node.js memory limit (`NODE_OPTIONS=--max_old_space_size=512`)
- TinyLLaMA instead of LLaMA 3.1 8B
- GPU-dependent features disabled by default

## Performance Tuning
```bash
# Increase swap for Pi 3/4
sudo dphys-swapfile swapoff
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
sudo dphys-swapfile setup && sudo dphys-swapfile swapon
```

## Known Limitations
- Deepfake detection slower without GPU
- Multiple AI models may cause memory pressure
- Consider external storage for logs/data
