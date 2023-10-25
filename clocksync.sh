#!/bin/bash

if [ $# -gt 1 ]; then
  echo "Usage: $0 <domain : null to UNSYNC>"
elif [ $# == 1 ]; then
  # Sync time to domain
  echo "[*] Syncing Clock with $1"
  sudo timedatectl set-ntp 0
  sudo ntpdate -u $1 && date
else # No Domain Provided
  # Unsync clock
  echo "[*] Unsyncing Clock"
  sudo ntpdate 0.debian.pool.ntp.org
  sudo hwclock --systohc
  sudo systemctl enable --now systemd-timesyncd
  sudo timedatectl set-ntp true
fi
