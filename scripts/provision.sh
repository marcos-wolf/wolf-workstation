#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "$0")/.." && pwd)"
apply=false
[[ $# == 0 || ( $# == 1 && $1 == --dry-run ) ]] || {
  [[ $# == 1 && $1 == --apply ]] || { echo 'Usage: provision.sh [--dry-run|--apply]' >&2; exit 2; }
  apply=true
}
steps=(bootstrap-core bootstrap-user-tools bootstrap-docker bootstrap-github-cli bootstrap-vscode bootstrap-aws bootstrap-desktop)
if ! "$apply"; then
  for step in "${steps[@]}"; do bash "$root/scripts/$step.sh"; done
  echo 'Then install managed shell config; preserve Firefox profiles and existing mise config.'
  echo 'Apply downloads tools; sudo, download confirmation and authentication may require interaction.'
  exit 0
fi
[[ $EUID != 0 ]] || { echo 'Run as your desktop user, not root.' >&2; exit 1; }
umask 077
state="${XDG_STATE_HOME:-$HOME/.local/state}/wolf-workstation"
mkdir -p "$state"
exec 9>"$state/provision.lock"
flock -n 9 || { echo 'Another provisioning run is active.' >&2; exit 1; }
exec > >(tee -a "$state/provision-$(date +%Y%m%d-%H%M%S).log") 2>&1
trap 'echo "Provisioning stopped at line $LINENO; correct the error and rerun the same command."' ERR
sudo -v
for step in "${steps[@]}"; do
  echo "=== $step ==="
  bash "$root/scripts/$step.sh" --apply
done
bash "$root/scripts/install-dotfiles.sh"
echo 'Complete. Reopen terminal. Docker group membership (root-equivalent) is optional:'
echo 'sudo usermod -aG docker "$USER" # then log out and log in'
echo 'Authenticate GitHub/AWS separately. Firefox Sync or encrypted profile recovery is optional.'
