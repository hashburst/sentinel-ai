# Contributing to SentinelAI

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR-USERNAME/sentinel-ai.git`
3. Add upstream: `git remote add upstream https://github.com/hashburst/sentinel-ai.git`
4. Initialize submodules: `make init-modules`
5. Install dependencies: `make deps`
6. Run tests: `make test`

## Development Workflow

1. Create a feature branch: `git checkout -b feature/your-feature-name`
2. Make your changes, write/update tests
3. Run `cargo fmt` and `cargo clippy` (Rust), `black` (Python)
4. Commit with a clear message and open a Pull Request

## Module Structure

```
modules/your-module/
├── README.md
├── src/
├── tests/
├── Dockerfile
├── requirements.txt
└── Cargo.toml
```

## Security Issues

Report vulnerabilities to g.pegoraro@bitcorp.it — do NOT open public issues.

## License

By contributing, you agree your contributions will be licensed under MIT.
