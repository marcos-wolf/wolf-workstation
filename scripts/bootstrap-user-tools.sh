#!/usr/bin/env bash

# Install user-scoped development tools and runtimes. The default is a preview;
# pass --apply to download and run the vendors' pinned installers.

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly VERSION_FILE="${REPOSITORY_ROOT}/config/user-tools.env"

apply=false

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-user-tools.sh [--apply]

Preview installation of mise, uv, and the runtimes declared in mise/config.toml.
Use --apply to install the pinned tool versions in the current user's home
directory. This script does not use sudo.
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

if [[ ! -f ${VERSION_FILE} ]]; then
  echo "Version file not found: ${VERSION_FILE}" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "${VERSION_FILE}"

if [[ ${apply} == false ]]; then
  cat <<EOF
Dry run: this script would:
  1. Install mise ${MISE_VERSION} in ~/.local/bin and configure Bash activation.
  2. Install uv ${UV_VERSION} in ~/.local/bin without changing shell profiles.
  3. Run mise install using mise/config.toml.

No changes were made. Run './scripts/bootstrap-user-tools.sh --apply' to continue.
EOF
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "Required command not found: curl" >&2
  exit 1
fi

mise_installer="$(mktemp)"
uv_installer="$(mktemp)"
trap 'rm -f "${mise_installer}" "${uv_installer}"' EXIT

echo "Downloading the mise Bash installer..."
curl --fail --location --silent --show-error https://mise.run/bash --output "${mise_installer}"

echo "Installing mise ${MISE_VERSION}..."
MISE_VERSION="${MISE_VERSION}" sh "${mise_installer}"

echo "Downloading the uv installer..."
curl --fail --location --silent --show-error \
  "https://astral.sh/uv/${UV_VERSION}/install.sh" \
  --output "${uv_installer}"

echo "Installing uv ${UV_VERSION}..."
UV_NO_MODIFY_PATH=1 sh "${uv_installer}"

echo "Installing runtimes declared in mise/config.toml..."
"${HOME}/.local/bin/mise" -C "${REPOSITORY_ROOT}" install --yes

echo "User tools bootstrap complete."
