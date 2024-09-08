#!/bin/bash

# Check for root usage
if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root." >&2; exit 1;
fi

# Fresh Install Update
apt update

# Install Tools, Binaries, and Wordlists
apt install -y python3-impacket impacket-scripts crackmapexec gobuster nodejs ntpdate

# Installs hwclock
apt-get install -y util-linux
apt install -y util-linux-extra

apt install -y seclists
mv /usr/share/seclists/ /usr/share/wordlists/Seclists

apt install -y neo4j bloodhound ncurses-hexedit
pip install bloodhound impacket ldap3 dnspython

# Make sure msf console & vemon are updated and ready
apt install -y metasploit-framework ghidra gdb jq

/usr/bin/vim +PlugInstall +qall

# Install Obsidian
wget 'https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage' -O Obsidian;
chmod +x Obsidian;
mv ./Obsidian -t /usr/local/bin

# Install my local bins
wget https://raw.githubusercontent.com/EndermanSUPREME/myKali_Scripts/main/clocksync.sh; chmod +x clocksync.sh; mv ./clocksync.sh /usr/local/bin/clocksync

# Final Updates / Upgrades
apt update
apt full-upgrade -y

echo '[+] VM Established!'
