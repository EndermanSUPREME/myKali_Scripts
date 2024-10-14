#!/bin/bash

# Check for root usage
if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root using sudo."
        exit
fi

# Fresh Install Update
apt update

# Install Tools, Binaries, and Wordlists
apt install -y python3-impacket impacket-scripts crackmapexec gobuster nodejs ntpdate

# Installs hwclock
apt-get install -y util-linux
apt install -y util-linux-extra

apt install -y seclists
rm -rf /usr/share/wordlists/seclists # attempt to delete syslink
mv /usr/share/seclists/ /usr/share/wordlists/Seclists

apt install -y neo4j bloodhound ncurses-hexedit
pip install bloodhound impacket ldap3 dnspython

# Make sure msf console & vemon are updated and ready
apt install -y metasploit-framework ghidra gdb jq

echo "Do you want to install extra configuration modules?"
echo "* VIM plugin"
echo "* clocksync.sh"
read -p "[y/n]: " userInput

# prompt about installing specific features
# such as VIM items and my clocksync binary
if [ "$userInput" == "y" ]; then
        # Install needed items to reconfigure my vim
        # settings in my ~/.vimrc
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        /usr/bin/vim +PlugInstall +qall
        
        # Install my local bins
        curl -O https://raw.githubusercontent.com/EndermanSUPREME/myKali_Scripts/main/clocksync.sh
        chmod +x clocksync.sh
        mv ./clocksync.sh /usr/local/bin/clocksync
fi

# Install Obsidian
wget 'https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage' -O Obsidian
chmod +x Obsidian
mv ./Obsidian -t /usr/local/bin

# Perform an Upgrade
apt full-upgrade -y

echo '[+] VM Established!'
