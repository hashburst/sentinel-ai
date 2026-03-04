# SentinelAI Windows Installer
Write-Host "========================================" -ForegroundColor Green
Write-Host "   SentinelAI Windows Installer v1.0   " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run as Administrator!" -ForegroundColor Red; exit 1
}

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

Write-Host "Installing prerequisites..." -ForegroundColor Yellow
choco install -y git python nodejs docker-desktop docker-compose

Write-Host "Configuring WSL2..." -ForegroundColor Yellow
wsl --install -d Ubuntu

Write-Host "Setting up Python..." -ForegroundColor Yellow
python -m venv venv; .\venv\Scripts\Activate.ps1
pip install --upgrade pip; pip install -r backend\requirements.txt

Write-Host "Installing Node.js packages..." -ForegroundColor Yellow
npm install -g pnpm; cd frontend; pnpm install; cd ..

Write-Host "Initializing submodules..." -ForegroundColor Yellow
git submodule update --init --recursive

Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation completed! Start with: make run" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
