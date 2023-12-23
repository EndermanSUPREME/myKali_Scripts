#!/bin/bash

exists()
{
  command -v "ntpdate" >/dev/null 2>&1
}

if [ ! exists ]; then
  echo "[-] ntpdate not installed on your machine!"
  sudo apt install ntpdate
fi

# Unsync clock
echo "[*] Unsyncing Clock"
sudo ntpdate 0.debian.pool.ntp.org
sudo hwclock --systohc
sudo systemctl enable --now systemd-timesyncd
sudo timedatectl set-ntp true

if [ $# -gt 1 ]; then
  echo "Usage: $0 <domain : null to UNSYNC>"
elif [ $# == 1 ]; then
  # Sync time to domain
  echo "[*] Syncing Clock with $1"
  sudo timedatectl set-ntp 0
  sudo ntpdate $1
fi
