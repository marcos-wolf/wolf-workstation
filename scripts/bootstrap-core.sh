#!/usr/bin/env bash

# Install the baseline packages that are available from Ubuntu's configured
# repositories. The default is a preview; pass --apply to make changes.

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly PACKAGE_LIST="${REPOSITORY_ROOT}/config/apt-packages.txt"

apply=false

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-core.sh [--apply]

Preview the Ubuntu APT packages required for the Wolf Workstation baseline.
Use --apply to update APT metadata and install missing packages.
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

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap script requires an Ubuntu/Debian system with APT." >&2
  exit 1
fi

if [[ ! -f ${PACKAGE_LIST} ]]; then
  echo "Package list not found: ${PACKAGE_LIST}" >&2
  exit 1
fi

mapfile -t packages < <(sed -E '/^[[:space:]]*(#|$)/d' "${PACKAGE_LIST}")

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "The package list is empty: ${PACKAGE_LIST}" >&2
  exit 1
fi

if [[ ${apply} == false ]]; then
  echo "Dry run: the following Ubuntu packages would be installed:"
  printf '  %s\n' "${packages[@]}"
  echo
  echo "No changes were made. Run '$0 --apply' to install them."
  exit 0
fi

echo "Updating APT package metadata..."
sudo apt-get update

echo "Installing Wolf Workstation baseline packages..."
sudo apt-get install --yes "${packages[@]}"

echo "Core bootstrap complete."
