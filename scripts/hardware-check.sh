#!/usr/bin/env bash

set -u

echo "========================================"
echo " Wolf Workstation - Hardware Check"
echo "========================================"
echo

echo "== CPU =="
lscpu
echo

echo "== Memory =="
free -h
echo
sudo dmidecode --type memory 2>/dev/null || echo "dmidecode unavailable"
echo

echo "== PCI devices =="
lspci
echo

echo "== Graphics =="
lspci -k | grep -A 3 -E "VGA|3D|Display"
echo

echo "== NVIDIA =="
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi
else
    echo "nvidia-smi not available"
fi
echo

echo "== Network interfaces =="
ip link
echo

echo "== NetworkManager devices =="
nmcli device status
echo

echo "== Block devices =="
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
echo

echo "== Firmware updates =="
fwupdmgr get-updates
echo

echo "== Firmware devices =="
fwupdmgr get-devices
echo

echo "========================================"
echo " Hardware Check Complete"
echo "========================================"
