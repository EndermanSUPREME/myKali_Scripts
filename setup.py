# Created on 9/3/23
# Created by Ender
# Github: https://github.com/EndermanSUPREME/myKali_Scripts

import os

def createBinary():
    shellScriptDir = ""
    privEscDir = ""
    chiselDir = ""

    while (os.path.isdir(shellScriptDir) == False):
        shellScriptDir = str(input("Enter in absolute path where you hold your Shell Scripts\n[ex '~/myShellScripts']: ")).replace("~", str(os.path.expanduser('~')))

    while (os.path.isdir(privEscDir) == False):
        privEscDir = str(input("Enter in absolute path where you hold your Privillage Esc. scripts\n[ex '~/myEscScripts']: ")).replace("~", str(os.path.expanduser('~')))

    while (os.path.isdir(chiselDir) == False):
        chiselDir = str(input("Enter in absolute path where you hold your Chisel Binary\n[ex '~/myTunnelScripts']: ")).replace("~", str(os.path.expanduser('~')))

    sourceScript = """#!/bin/bash

usage="Usage: spawnTerminal [TYPE]\\n\\nTYPES:\\nNo Type - open new instance in current dir\\nshell - open new terminal in {0}\\nchisel - open new terminal to set up chisel\\npriv - opens new terminal in {1} dir\\nhelp - help menu"

function showUsage {
    echo -e $usage
    exit
}

if [ "$#" -lt 1 ]; then
    exec qterminal & #the & allows the app to open as its own process
    exit
elif [ "$#" == 1 ]; then
    if [ "$1" == "help" ]; then
        showUsage
    elif [ "$1" == "shell" ]; then
        exec qterminal -w {0} &
    elif [ "$1" == "priv" ]; then
        exec qterminal -w {1} &
    elif [ "$1" == "chisel" ]; then
        exec qterminal -w {2} &
    else
        echo "Invalid Type!"
        showUsage
    fi
else
    showUsage
fi
exit"""
    
    fContents = sourceScript.replace("{0}", str(shellScriptDir)).replace("{1}", str(privEscDir)).replace("{2}", str(chiselDir))
    return fContents

def createApplication():
    spawnTerminal = open("./spawnTerminal.sh", "w")
    spawnTerminal.write(createBinary())
    spawnTerminal.close()

    os.system("chmod +x ./spawnTerminal.sh; mv ./spawnTerminal.sh ./spawnTerminal")

    print("\n[+] ./spawnTerminal has been Created Successfully!")
    print("\n[*] Run sudo mv to move ./spawnTerminal to /usr/bin or /usr/local/bin\nTo allow access to this binary from anywhere!")
    print("\n[*] Run [spawnTerminal help] or [./spawnTerminal help] to see the help menu!\nHave a Good Day! :3")

def main():
    print("[*] Building spawnTerminal Binary\n")
    createApplication()

if __name__ == "__main__":
    main()
