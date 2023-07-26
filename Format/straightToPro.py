import time, sys
import requests, os.path

sess_cookie = {}
cookieChunk = ""
headerData = {
    'Host':'app.microblog.htb',
    'User-Agent':'Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0',
    'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Content-Type':'application/x-www-form-urlencoded'
    }

def main():
    if len(sys.argv) > 1:
        FetchSessionCookie()
    else:
        print("[-] Missing Data!")
        print("[*] Usage: python3 straightToPro.py cookie-value")

def FetchSessionCookie():
    cookieReq = requests.post("http://app.microblog.htb/index.php")

    #cookieJaw = str(cookieReq.cookies)
    #cookieChunk = cookieJaw[27:62]
    cookieChunk="username=" + str(sys.argv[1])

    sess_cookie = {'Cookie':cookieChunk}

    if os.path.exists("./cookie.txt"):
        print("[+] File Exists")
        cookieFile = open("cookie.txt", "r")
        if cookieFile.read() != str(sys.argv[1]):
            cookieFile = open("cookie.txt", "w")
            cookieFile.write(str(sys.argv[1]))
            cookieFile.close()
    else:
        print("[*] Creating Cookie File")
        cookieFile = open("cookie.txt", "x") # create new file
        cookieFile = open("cookie.txt", "w")
        cookieFile.write(str(sys.argv[1]))
        cookieFile.close()


    print("[+] Cookie File Made: cookie.txt")
    print("[*] Session Cookie: " + str(sess_cookie))
    print("[+] New Session Cookie: " + str(cookieChunk))

    CreateAccount()

def CreateAccount():
    Data={'first-name':'john','last-name':'adam','username':'john','password':'apple'}
    print("[+] Login john:apple Ready!")
    requests.post("http://app.microblog.htb/register/index.php", data=Data, headers=headerData, cookies=sess_cookie, allow_redirects=True)

if __name__ == "__main__":
    main()
