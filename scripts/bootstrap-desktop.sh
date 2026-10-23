#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "$0")/.." && pwd)"
if [[ $# == 0 || ${1:-} == --dry-run ]]; then
  echo 'Install missing VS Code extensions, Firefox snap and official OnlyOffice DEB; ask before downloading.'
  exit 0
fi
[[ $# == 1 && $1 == --apply ]] || exit 2
while IFS= read -r extension; do
  code --install-extension "$extension"
done < "$root/config/vscode-extensions.txt"
if ! command -v firefox >/dev/null; then sudo snap install firefox; fi
if ! dpkg-query -W -f='${Status}' onlyoffice-desktopeditors 2>/dev/null | grep -qx 'install ok installed'; then
  url=https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
  curl --fail --location --head "$url"
  read -r -p 'Download OnlyOffice (size above) plus APT dependencies? [y/N] ' answer
  [[ $answer == y || $answer == Y ]] || exit 1
  cache="${XDG_CACHE_HOME:-$HOME/.cache}/wolf-workstation"
  mkdir -p "$cache"
  curl --fail --location --retry 3 --continue-at - "$url" -o "$cache/onlyoffice.deb"
  dpkg-deb --info "$cache/onlyoffice.deb" >/dev/null
  sudo apt-get install --yes "$cache/onlyoffice.deb"
fi
