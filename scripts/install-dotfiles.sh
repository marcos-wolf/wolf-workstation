#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly SOURCE="${REPOSITORY_ROOT}/dotfiles/bash/wolf-workstation.bash"
readonly TARGET_DIR="${HOME}/.config/wolf-workstation"
readonly TARGET="${TARGET_DIR}/bashrc"
readonly BASHRC="${HOME}/.bashrc"
readonly MARKER="# Wolf Workstation"

if [[ ! -f ${SOURCE} ]]; then
    echo "Dotfile source not found: ${SOURCE}" >&2
    exit 1
fi

mkdir -p "${TARGET_DIR}"

if [[ -f ${TARGET} ]] && ! cmp -s "${SOURCE}" "${TARGET}"; then
    backup="${TARGET}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Existing configuration differs."
    echo "Creating backup: ${backup}"
    cp "${TARGET}" "${backup}"
fi

install -m 644 "${SOURCE}" "${TARGET}"

if [[ ! -f ${BASHRC} ]]; then
    touch "${BASHRC}"
fi

if ! grep -Fqx "${MARKER}" "${BASHRC}"; then
    cat >> "${BASHRC}" <<'EOF'

# Wolf Workstation
[ -f "$HOME/.config/wolf-workstation/bashrc" ] && . "$HOME/.config/wolf-workstation/bashrc"
EOF
    echo "Added Bash integration to: ${BASHRC}"
else
    echo "Bash integration already present."
fi

echo "Installed: ${TARGET}"
