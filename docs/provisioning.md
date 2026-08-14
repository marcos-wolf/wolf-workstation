# Provisioning

This repository is being prepared to rebuild the Wolf Workstation from a clean
Ubuntu installation. Provisioning is split by software source so that it is
reviewable, repeatable and does not silently add third-party repositories.

## Core Ubuntu packages

`config/apt-packages.txt` is the declarative list of baseline packages supplied
by Ubuntu's already-configured APT repositories. It covers the native toolchain,
common command-line tools, Flatpak support and firmware tooling.

Preview the installation from the repository root:

```bash
./scripts/bootstrap-core.sh
```

The preview makes no changes. After reviewing the list, install it with:

```bash
./scripts/bootstrap-core.sh --apply
```

The script is safe to re-run: APT leaves already-installed packages unchanged.

## Separate sources

The following tools require their own official installation sources or personal
authentication. They are deliberately not installed by `bootstrap-core.sh`:

- Docker Engine and Docker Compose plugin
- Visual Studio Code
- GitHub CLI
- AWS CLI
- mise, Node.js and pnpm
- Flatpak applications

Their exact setup should be recorded before an automated installer is added.
Credentials, SSH keys and cloud configuration remain machine-specific and are
never provisioned by this repository.

The current source choices and installed versions are recorded in
[`docs/external-tools.md`](external-tools.md).

## Rebuild order

1. Install Ubuntu and apply system updates.
2. Clone this repository.
3. Review and run the core bootstrap.
4. Run `./scripts/bootstrap-user-tools.sh` to install mise, uv and the declared
   runtimes without requiring administrator access.
5. Run the opt-in system-wide bootstraps, starting with
   `./scripts/bootstrap-github-cli.sh`.
6. Run `./scripts/system-check.sh` and the project validation commands.
