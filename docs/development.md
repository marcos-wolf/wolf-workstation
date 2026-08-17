# Development Environment

## Editor

Visual Studio Code is the primary development environment.

Installation source:

- Microsoft APT repository

### Reproducible bootstrap

The repository includes an opt-in installer for the official Microsoft APT
repository and the stable `code` package:

```bash
./scripts/bootstrap-vscode.sh
./scripts/bootstrap-vscode.sh --apply
```

The preview makes no changes. The installation does not install extensions,
sign in to any service, or modify editor preferences.

## Version Control

- Git
- GitHub CLI
- SSH authentication

## Languages

- Python
- C
- C++
- JavaScript / TypeScript
- Java

Detailed Python development standards are documented in
[`docs/python.md`](python.md).

## Planned Infrastructure

- Docker
- Docker Compose
- AWS CLI
- Terraform
- kubectl
- Helm

## Principles

Development tools should be installed from appropriate and reproducible sources.

Project-specific dependencies should preferably remain isolated from the global system.

Global development tooling should be kept to a minimum.
