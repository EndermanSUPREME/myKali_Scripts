#!/bin/bash

if [ $# -gt 1 ]; then
  echo "Usage: $0 <domain : null to UNSYNC>"
elif [ $# == 1 ]
  # Sync time to domain
  sudo timedatectl set-ntp 0
  sudo ntpdate -u $1 && date
else # No Domain Provided
  # Unsync clock
  sudo ntpdate 0.debian.pool.ntp.org
  sudo hwclock --systohc
  sudo systemctl enable --now systemd-timesyncd
  sudo timedatectl set-ntp true
fi
