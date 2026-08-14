# External Tools

The core bootstrap installs packages from Ubuntu's configured repositories. This
document records the separate, official sources used for tools that have their
own release or repository lifecycle. No credentials are stored here.

## User-scoped tools

These tools install in `~/.local/bin` and should remain independent of the
system package manager.

| Tool | Source and policy | Current workstation version |
| --- | --- | --- |
| mise | Official mise installer with Bash activation | 2026.8.3 |
| uv | Official Astral standalone installer | 0.12.3 |
| AWS CLI | Official AWS user-scoped installer | 2.36.21 |

The official mise Bash installer adds activation to `~/.bashrc` and is safe to
re-run. The official uv and AWS installers place their binaries in
`~/.local/bin`; the user's login environment must include that directory in
`PATH`.

Use the version configuration in `mise/config.toml` after installing mise:

```bash
mise install
```

This installs the Node.js and pnpm versions declared by the repository without
putting them under APT control.

## System-wide tools

| Tool | Official source | Current workstation version |
| --- | --- | --- |
| Docker Engine | Docker APT repository | 29.7.2 |
| Visual Studio Code | Microsoft APT repository | 1.133.0 |
| GitHub CLI | GitHub CLI APT repository | 2.46.0 (Ubuntu package) |

Docker and Visual Studio Code are already installed from their vendors' APT
repositories. Their repository configuration must be preserved as versioned
instructions before it is automated.

The installed GitHub CLI is currently the Ubuntu package. GitHub CLI's official
installation guide recommends its official Debian repository instead of the
community Ubuntu package line. A future bootstrap step should migrate `gh` to
that repository; authentication remains a separate manual action with
`gh auth login`.

The repository bootstrap is available now and is opt-in:

```bash
./scripts/bootstrap-github-cli.sh
./scripts/bootstrap-github-cli.sh --apply
```

The first command is a preview. The second downloads GitHub's signing key,
adds its signed APT repository, and installs or updates `gh`. It does not run
`gh auth login` or write authentication tokens.

## Official references

- [mise installation](https://mise.jdx.dev/installing-mise.html)
- [uv installation](https://docs.astral.sh/uv/getting-started/installation/)
- [Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Visual Studio Code on Linux](https://code.visualstudio.com/docs/setup/linux)
- [GitHub CLI for Linux](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
- [AWS CLI on Linux](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## Provisioning policy

Installers that download external code must be explicit and opt-in. They should
first download the vendor script or package to a temporary location, then run
it only with an `--apply` flag. This prevents a normal repository checkout or
a CI job from modifying the host system.
