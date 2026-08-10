#!/usr/bin/env bash

set -u

echo "========================================"
echo " Wolf Workstation - System Check"
echo "========================================"
echo

echo "== Date =="
date
echo

echo "== Hostname =="
hostnamectl --static
echo

echo "== Ubuntu =="
cat /etc/os-release
echo

echo "== Kernel =="
uname -a
echo

echo "== Desktop Session =="
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-unknown}"
echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-unknown}"
echo

echo "== GNOME =="
gnome-shell --version 2>/dev/null || echo "GNOME Shell version unavailable"
echo

echo "== Failed systemd services =="
systemctl --failed --no-pager
echo

echo "== APT packages that can be upgraded =="
apt list --upgradable 2>/dev/null
echo

echo "== Snap =="
snap version
echo
snap list
echo

echo "== Flatpak =="
flatpak --version
echo
flatpak list
echo

echo "== Swap =="
swapon --show
echo
free -h
echo

echo "== Disk usage =="
df -h
echo

echo "== Recent kernel/system errors =="
journalctl -b -p err --no-pager
echo

echo "========================================"
echo " System Check Complete"
echo "========================================"
