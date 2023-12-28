#!/bin/bash

# Check for root usage
if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root." >&2; exit 1;
fi

# Fresh Install Update
apt update

# Install Tools, Binaries, and Wordlists

apt install python3-impacket
apt install impacket-scripts

# special fork of impacket
git clone https://github.com/ShutdownRepo/impacket/
cd impacket
git checkout getuserspns-nopreauth
# take new impacket scripts and relocate them
cp ./examples /usr/share/doc/python3-impacket/examples
cd ../
rm -r ./impacket

# normal installs
apt install crackmapexec

apt install seclists
mv /usr/share/seclists/ /usr/share/wordlists/Seclists

apt install neo4j

apt update && apt install -y bloodhound

pip install bloodhound impacket ldap3 dnspython

apt install ncurses-hexedit

# Install Obsidian
wget 'https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage' -O Obsidian; chmod +x Obsidian; mv ./Obsidian -t /usr/local/bin

# Install my local bins
wget https://github.com/EndermanSUPREME/myKali_Scripts/blob/main/setup.py
python3 setup.py
mv ./spawnTerminal -t /usr/local/bin/

wget https://github.com/EndermanSUPREME/myKali_Scripts/blob/main/clocksync.sh; chmod +x clocksync.sh; mv ./clocksync.sh /usr/local/bin/clocksync

# Final Updates / Upgrades
apt update; apt full-upgrade -y