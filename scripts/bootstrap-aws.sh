#!/usr/bin/env bash
set -euo pipefail
if [[ $# == 0 || ${1:-} == --dry-run ]]; then
  echo 'Install AWS CLI from the signed Ubuntu repositories (no credentials).'
  exit 0
fi
[[ $# == 1 && $1 == --apply ]] || exit 2
# Ubuntu maintains this package; avoid running an unverified downloaded ZIP.
sudo apt-get install --yes awscli
aws --version
