# AWS CLI

The AWS Command Line Interface (AWS CLI) is installed as part of the Wolf Workstation cloud development environment.

## Installation

AWS CLI is installed using the official AWS CLI v2 installer.

Verify the installation with:

```bash
aws --version
which aws
```

## Authentication

AWS credentials are intentionally not stored in this repository.

Authentication should be configured separately when AWS access is required.

Do not commit:

- AWS access keys
- AWS secret access keys
- Session tokens
- Credential files
- Private keys
- Other cloud credentials

## Validation

The CLI installation was validated locally with:

```bash
aws --version
```

No AWS account authentication is required for the workstation installation itself.
