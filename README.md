# Wolf Workstation

Reproducible Linux workstation for software development.

## Goals

- Reproducible
- Documented
- Version controlled
- Portable between machines
- Stable for development
- Separated from Windows gaming environment

## Stack

- Ubuntu
- Git
- GitHub
- Python
- C/C++
- Node.js
- Docker
- AWS
- Terraform
- Kubernetes
- AI and automation tools

## Philosophy

The workstation should be possible to rebuild from a clean Ubuntu installation with minimal manual configuration.

Configuration, scripts and documentation should be version controlled whenever practical.

## Status

Work in progress.

## Provisioning

The first reproducible provisioning layer is documented in
[`docs/provisioning.md`](docs/provisioning.md). It previews the Ubuntu package
baseline by default and only changes the system when explicitly run with
`--apply`.
