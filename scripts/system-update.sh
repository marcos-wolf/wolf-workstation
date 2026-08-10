#!/usr/bin/env bash

set -e

echo "========================================"
echo " Wolf Workstation - System Update"
echo "========================================"
echo

echo "== Updating APT package lists =="
sudo apt update
echo

echo "== Upgrading APT packages =="
sudo apt upgrade
echo

echo "== Updating Snap packages =="
sudo snap refresh
echo

echo "== Updating Flatpak packages =="
flatpak update
echo

echo "== Checking removable APT packages =="
sudo apt autoremove --dry-run
echo

echo "== Checking firmware updates =="
fwupdmgr get-updates
echo

echo "========================================"
echo " System Update Complete"
echo "========================================"
