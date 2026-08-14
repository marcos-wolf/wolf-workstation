#!/usr/bin/env bash

# Configure Docker's official APT repository and install Docker Engine.
# The default is a preview; pass --apply to change the system.

set -euo pipefail

apply=false

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-docker.sh [--apply]

Preview installation of Docker Engine from Docker's official APT repository.
Use --apply to add the signed repository and install Docker Engine, Buildx, and
the Docker Compose plugin. The current user is not added to the docker group.
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
  1. Download Docker's official APT signing key.
  2. Add Docker's signed stable repository for the current Ubuntu release.
  3. Install Docker Engine, Buildx, and the Docker Compose plugin.
  4. Enable and start the Docker service.

No changes were made. Run './scripts/bootstrap-docker.sh --apply' to continue.
EOF
  exit 0
fi

for command in apt-get curl dpkg install mktemp systemctl; do
  if ! command -v "${command}" >/dev/null 2>&1; then
    echo "Required command not found: ${command}" >&2
    exit 1
  fi
done

if [[ ! -r /etc/os-release ]]; then
  echo "Cannot determine the Ubuntu release: /etc/os-release is unavailable." >&2
  exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
ubuntu_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
if [[ -z ${ubuntu_codename} ]]; then
  echo "Cannot determine the Ubuntu release codename." >&2
  exit 1
fi

key_file="$(mktemp)"
trap 'rm -f "${key_file}"' EXIT

echo "Installing Docker repository prerequisites..."
sudo apt-get update
sudo apt-get install --yes ca-certificates curl

echo "Downloading Docker's signing key..."
curl --fail --location --silent --show-error \
  https://download.docker.com/linux/ubuntu/gpg \
  --output "${key_file}"

echo "Configuring Docker's APT repository..."
sudo install -d -m 755 /etc/apt/keyrings /etc/apt/sources.list.d
sudo install -m 644 "${key_file}" /etc/apt/keyrings/docker.asc

architecture="$(dpkg --print-architecture)"
printf '%s\n' \
  'Types: deb' \
  'URIs: https://download.docker.com/linux/ubuntu' \
  "Suites: ${ubuntu_codename}" \
  'Components: stable' \
  "Architectures: ${architecture}" \
  'Signed-By: /etc/apt/keyrings/docker.asc' \
  | sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null

echo "Updating APT metadata..."
sudo apt-get update

echo "Installing Docker Engine..."
sudo apt-get install --yes \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo "Enabling Docker service..."
sudo systemctl enable --now docker

echo "Installed Docker version:"
docker --version
docker compose version

cat <<'EOF'

Docker is installed. To run Docker without sudo, explicitly add the desired user
to the docker group, then start a new login session. Treat this as privileged
access to the host.
EOF
