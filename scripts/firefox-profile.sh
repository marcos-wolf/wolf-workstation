#!/usr/bin/env bash
# Encrypt a closed Firefox profile or restore it into a NEW directory only.
set -euo pipefail
umask 077
[[ $# == 3 ]] || { echo 'Usage: firefox-profile.sh backup PROFILE NEW.gpg | restore BACKUP.gpg NEW_DIRECTORY'; exit 2; }
mode=$1; source=$2; destination=$3
if pgrep -u "$(id -u)" -f '(^|/)(firefox|firefox-bin)( |$)' >/dev/null; then
  echo 'Close Firefox first.' >&2; exit 1
fi
[[ ! -e $destination && ! -L $destination ]] || { echo 'Destination already exists; refusing overwrite.' >&2; exit 1; }
case $mode in
 backup)
  [[ -d $source && -f $source/prefs.js ]] || { echo 'Select a Firefox profile containing prefs.js.' >&2; exit 1; }
  # Output must stay outside any Git worktree.
  parent=$(realpath "$(dirname -- "$destination")")
  if git -C "$parent" rev-parse --show-toplevel >/dev/null 2>&1; then echo 'Choose encrypted external storage outside Git.' >&2; exit 1; fi
  trap 'rm -f -- "$destination"' ERR
  tar -C "$source" -czf - . | gpg --symmetric --cipher-algo AES256 --output "$destination"
  ;;
 restore)
  # Python validates every member before extraction; links and traversal rejected.
  temp=$(mktemp); trap 'rm -f "$temp"' EXIT
  gpg --decrypt --output "$temp" "$source"
  python3 - "$temp" "$destination" <<'PYTHON'
import pathlib, sys, tarfile
with tarfile.open(sys.argv[1]) as archive:
    for member in archive.getmembers():
        p = pathlib.PurePosixPath(member.name)
        if p.is_absolute() or '..' in p.parts or not (member.isfile() or member.isdir()):
            raise SystemExit('Unsafe archive member')
    pathlib.Path(sys.argv[2]).mkdir(mode=0o700)
    archive.extractall(sys.argv[2], filter='data')
PYTHON
  echo 'Recovered to a new directory. Open Firefox about:profiles to register and select it.'
  ;;
 *) exit 2 ;;
esac
