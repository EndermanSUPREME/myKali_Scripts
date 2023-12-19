import sys, os
from decimal import Decimal

if len(sys.argv) == 2:
    cgroupFile = sys.argv[1]

    if (os.path.isfile(cgroupFile)):
        cgroupString = open(str(cgroupFile),'r').readline()
        print("cgroup: " + cgroupString.strip().rpartition("/")[2])

        print("nodeuuids: " + str(0x005056b91188))
else:
    print("[*] Usage: python3 script.py [cgroup file] [mac addr]")