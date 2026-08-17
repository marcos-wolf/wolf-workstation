# Provisioning

The Wolf Workstation is designed to be rebuilt from a clean Ubuntu installation using the configuration and scripts stored in this repository.

Provisioning is divided by software source so that each installation method is explicit, reviewable, and repeatable.

---

## Core Ubuntu Packages

`config/apt-packages.txt` contains the baseline packages supplied by Ubuntu's configured APT repositories.

These packages provide the native development toolchain, common command-line utilities, firmware tooling, and Flatpak support.

Preview the installation from the repository root:

```bash
./scripts/bootstrap-core.sh
```
*The preview makes no changes.*

After reviewing the package list, install it with:

```bash
./scripts/bootstrap-core.sh --apply
```
*The script is safe to re-run. Already-installed APT packages are left unchanged.*

---

## User-Scoped Development Tools

The repository provides an automated bootstrap for user-scoped development tools.

The versions are declared in:
- `config/user-tools.env`
- `mise/config.toml`

Preview the installation:

```bash
./scripts/bootstrap-user-tools.sh
```

Apply the installation:

```bash
./scripts/bootstrap-user-tools.sh --apply
```

The bootstrap installs mise and uv, then installs the Node.js and pnpm
versions declared in `mise/config.toml`.

> `mise/config.toml` is the source of truth for the Node.js and pnpm versions.

---

## Docker

Docker Engine is installed through Docker's official APT repository.

Preview:
```bash
./scripts/bootstrap-docker.sh
```

Apply:
```bash
./scripts/bootstrap-docker.sh --apply
```

The bootstrap installs Docker Engine, Buildx, and the Docker Compose plugin.
See [`docs/infrastructure/docker.md`](infrastructure/docker.md) for details.

---

## GitHub CLI

GitHub CLI is installed through its official APT repository.

Preview:
```bash
./scripts/bootstrap-github-cli.sh
```

Apply:
```bash
./scripts/bootstrap-github-cli.sh --apply
```

*Authentication is intentionally not automated.*

After installation, authenticate interactively:
```bash
gh auth login
```

Verify the authentication:
```bash
gh auth status
```

SSH authentication for Git operations is documented separately in [`docs/backup.md`](backup.md).

---

## Visual Studio Code

Visual Studio Code is installed through Microsoft's official APT repository.

Preview:
```bash
./scripts/bootstrap-vscode.sh
```

Apply:
```bash
./scripts/bootstrap-vscode.sh --apply
```

The bootstrap installs or updates the `code` package.

VS Code extensions are not automatically installed by the workstation bootstrap because extension requirements are generally project-specific.

---

# AWS CLI

AWS CLI is installed using the official AWS CLI v2 installer.

The AWS CLI installation is currently documented but not automated by the workstation bootstrap.

The workstation installation does not configure AWS credentials.

Verify the installation:

```bash
aws --version
```

If AWS access is required, configure authentication separately according to the project's security requirements.

See [`docs/infrastructure/aws-cli.md`](infrastructure/aws-cli.md).

---

## Flatpak

The core bootstrap installs Flatpak support. Flatpak applications are intentionally not installed automatically by the workstation bootstrap.

Desktop applications can be installed separately according to the user's requirements.

---

## Dotfiles

Shell configuration is stored in the repository under:
`dotfiles/`

Install the managed dotfiles with:
```bash
./scripts/install-dotfiles.sh
```

The installer creates a backup of an existing managed file before replacing it.

---

## System and Hardware Validation

After provisioning, run:
```bash
./scripts/system-check.sh
```

Hardware-specific validation can be performed with:
```bash
./scripts/hardware-check.sh
```

> **Note:** Hardware validation is intentionally performed locally rather than in CI, because GitHub Actions runners do not represent the target workstation hardware.

---

## System Updates

System updates are handled separately from provisioning:

```bash
./scripts/system-update.sh
```

Provisioning establishes the workstation environment. Updating keeps the installed Ubuntu system current.

---

## Rebuild Order

A clean Ubuntu recovery should follow this general order:

1. Install Ubuntu.
2. Apply the initial Ubuntu system updates.
3. Install Git if it is not already available.
4. Clone this repository.
5. Review and apply the core Ubuntu bootstrap.
6. Install the user-scoped development tools.
7. Install Docker.
8. Install GitHub CLI.
9. Install Visual Studio Code.
10. Restore or regenerate credentials as documented in [`docs/backup.md`](backup.md).
11. Install or restore required dotfiles.
12. Restore persistent user data.
13. Run system and hardware validation.
14. Recreate development project dependencies.
15. Recreate Docker development environments.
16. Run the repository's CI-equivalent validation checks.

---

## Provisioning Policy

Provisioning scripts should follow these principles:

- Prefer official vendor repositories or installers when Ubuntu's repository does not provide the desired tool.
- Avoid silently adding third-party repositories.
- Default to preview or dry-run behavior when practical.
- Require explicit `--apply` for system-changing external installers.
- Keep credentials and secrets outside the repository.
- Keep regenerable state outside the backup.
- Make scripts safe to re-run whenever practical.
- Keep the repository as the source of truth for workstation configuration.
