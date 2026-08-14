#!/usr/bin/env bash

# Configure GitHub's official APT repository and install GitHub CLI.
# The default is a preview; pass --apply to change the system.

set -euo pipefail

apply=false

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-github-cli.sh [--apply]

Preview installation of GitHub CLI from GitHub's official APT repository.
Use --apply to add the signed repository and install or update gh.
EOF
}

if [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then
  usage
  exit 0
fi

if [[ ${1:-} == "--apply" ]]; then
  apply=true
elif [[ $# -gt 0 ]]; then
  usage >&2
  exit 2
fi

if [[ ${apply} == false ]]; then
  cat <<'EOF'
Dry run: this script would:
  1. Download GitHub CLI's official APT signing key.
  2. Add https://cli.github.com/packages as a signed APT source.
  3. Update APT metadata and install or update gh.

No changes were made. Run './scripts/bootstrap-github-cli.sh --apply' to continue.
EOF
  exit 0
fi

for command in apt-get curl dpkg install mktemp; do
  if ! command -v "${command}" >/dev/null 2>&1; then
    echo "Required command not found: ${command}" >&2
    exit 1
  fi
done

key_file="$(mktemp)"
trap 'rm -f "${key_file}"' EXIT

echo "Downloading the GitHub CLI signing key..."
curl --fail --location --silent --show-error \
  https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  --output "${key_file}"

echo "Configuring the GitHub CLI APT repository..."
sudo install -d -m 755 /etc/apt/keyrings /etc/apt/sources.list.d
sudo install -m 644 "${key_file}" /etc/apt/keyrings/githubcli-archive-keyring.gpg

architecture="$(dpkg --print-architecture)"
printf '%s\n' \
  "deb [arch=${architecture} signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

echo "Updating APT metadata..."
sudo apt-get update

echo "Installing GitHub CLI..."
sudo apt-get install --yes gh

echo "Installed GitHub CLI version:"
gh --version | head -n 1
