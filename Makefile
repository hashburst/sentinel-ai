.PHONY: help build run test clean deps docker-dev docker-prod test-os benchmark security-scan init-modules

help:
	@echo "SentinelAI Makefile"
	@echo "Available commands:"
	@echo "  make build         - Build application"
	@echo "  make run           - Run in development mode"
	@echo "  make test          - Run test suite"
	@echo "  make test-os OS=X  - Test specific OS"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make deps          - Install dependencies"
	@echo "  make docker-dev    - Start with Docker Compose (dev)"
	@echo "  make docker-prod   - Start with Docker Compose (prod)"
	@echo "  make benchmark     - Run benchmarks"
	@echo "  make security-scan - Scan for vulnerabilities"
	@echo "  make init-modules  - Initialize and update submodules"

build:
	cargo build --release
	cd frontend && pnpm build

run:
	cargo run --release

test:
	cargo test
	cd frontend && pnpm test
	pytest modules/cognitive-security/tests/
	pytest modules/tep-protocol/tests/

test-os:
	@echo "Testing on $(OS)..."
	cd test-environments/$(OS) && ./run_tests.sh

clean:
	cargo clean
	rm -rf frontend/dist
	rm -rf venv
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

deps:
	pip install -r backend/requirements.txt
	cd frontend && pnpm install

docker-dev:
	docker-compose up --build

docker-prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

benchmark:
	python3 scripts/benchmark.py --threads 16 --duration 300

security-scan:
	trivy fs --severity HIGH,CRITICAL .
	grype dir:. || true

init-modules:
	git submodule update --init --recursive
	git submodule foreach git pull origin main
