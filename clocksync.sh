#!/bin/bash

exists()
{
  command -v "rdate" >/dev/null 2>&1
}

if [ ! exists ]; then
  clear
  echo "[-] rdate not installed on your machine!";
  sudo apt install rdate -y
  echo "[+] rdate has been installed on your machine!";
  echo;
  continue
fi

# Perform a setup to disable time sync?
sudo timedatectl set-ntp 0

# rdate and ntpdate commands work
# if you have clock skew issues against windows targets
# if you are using Oracle VM you will need to run this
# command on the Host machine.
# (Windows) cmd.exe | .\VBoxManage.exe setextradata "VM Name" "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled"
if [ $# -gt 1 ]; then
  echo "Usage: $0 <domain : null to UNSYNC>"
elif [ $# == 1 ]; then
  # Sync time to domain
  echo "[*] Syncing Clock with $1"
  sudo rdate -n $1
fi
