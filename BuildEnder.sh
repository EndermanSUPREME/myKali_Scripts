#!/bin/bash

# Check for root usage
if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root." >&2; exit 1;
fi

# run an input test so if the user wishes for pure automation
# they can have it set up
echo "Did you run '#0 < yes'?"
read yesTest

if [ yesTest != "y" ]; then
        exit 0;
fi

# Fresh Install Update
apt update

# Install Tools, Binaries, and Wordlists

apt install python3-impacket
apt install impacket-scripts
apt install crackmapexec
apt install gobuster
apt install nodejs

apt install ntpdate
# Installs hwclock
apt-get install util-linux
apt install util-linux-extra

apt install seclists
mv /usr/share/seclists/ /usr/share/wordlists/Seclists

apt install neo4j
apt update && apt install -y bloodhound
pip install bloodhound impacket ldap3 dnspython

apt install ncurses-hexedit

// make sure msf console & vemon are updated and ready
apt install metasploit-framework

apt install ghidra
apt install gdb

apt install jq

# Install Obsidian
wget 'https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage' -O Obsidian;
chmod +x Obsidian;
mv ./Obsidian -t /usr/local/bin

# Install my local bins
wget https://raw.githubusercontent.com/EndermanSUPREME/myKali_Scripts/main/setup.py -O buildSpawnTerminal.py

wget https://raw.githubusercontent.com/EndermanSUPREME/myKali_Scripts/main/clocksync.sh; chmod +x clocksync.sh; mv ./clocksync.sh /usr/local/bin/clocksync

# Final Updates / Upgrades
apt update; apt full-upgrade -y

# Final Notes
clear
echo '[*] python3 buildSpawnTerminal.py : will need to be Manually ran!'
echo 'To allow Impacket to work properly, ensure you add this line to ~/.bashrc:'
echo '----> export PYTHONPATH=$PYTHONPATH:/usr/lib/python3/dist-packages'
echo '[+] VM Established!'
