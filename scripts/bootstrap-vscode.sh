#!/usr/bin/env bash

# Configure Microsoft's official APT repository and install Visual Studio Code.
# The default is a preview; pass --apply to change the system.

set -euo pipefail

apply=false

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-vscode.sh [--apply]

Preview installation of Visual Studio Code from Microsoft's official APT
repository. Use --apply to add the signed repository and install or update code.
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
  1. Download Microsoft's official APT signing key.
  2. Add the signed Visual Studio Code stable repository.
  3. Update APT metadata and install or update code.

No changes were made. Run './scripts/bootstrap-vscode.sh --apply' to continue.
EOF
  exit 0
fi

for command in apt-get curl gpg install mktemp; do
  if ! command -v "${command}" >/dev/null 2>&1; then
    echo "Required command not found: ${command}" >&2
    exit 1
  fi
done

key_file="$(mktemp)"
keyring_file="$(mktemp)"
trap 'rm -f "${key_file}" "${keyring_file}"' EXIT

echo "Installing Visual Studio Code repository prerequisites..."
sudo apt-get update
sudo apt-get install --yes curl gpg

echo "Downloading Microsoft's signing key..."
curl --fail --location --silent --show-error \
  https://packages.microsoft.com/keys/microsoft.asc \
  --output "${key_file}"
gpg --dearmor --output "${keyring_file}" "${key_file}"

echo "Configuring the Visual Studio Code APT repository..."
sudo install -d -m 755 /usr/share/keyrings /etc/apt/sources.list.d
sudo install -m 644 "${keyring_file}" /usr/share/keyrings/microsoft.gpg
printf '%s\n' \
  'Types: deb' \
  'URIs: https://packages.microsoft.com/repos/code' \
  'Suites: stable' \
  'Components: main' \
  'Architectures: amd64,arm64,armhf' \
  'Signed-By: /usr/share/keyrings/microsoft.gpg' \
  | sudo tee /etc/apt/sources.list.d/vscode.sources >/dev/null

echo "Updating APT metadata..."
sudo apt-get update

echo "Installing Visual Studio Code..."
sudo apt-get install --yes code

echo "Installed Visual Studio Code version:"
code --version | head -n 1
