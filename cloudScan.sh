#!/bin/bash
# Cloud Scale Scan

echo '
   ________                __   _____                
  / ____/ /___  __  ______/ /  / ___/_________ _____ 
 / /   / / __ \/ / / / __  /   \__ \/ ___/ __ `/ __ \
/ /___/ / /_/ / /_/ / /_/ /   ___/ / /__/ /_/ / / / /
\____/_/\____/\__,_/\__,_/   /____/\___/\__,_/_/ /_/ 
                                                    
'

# Check if masscan installed, if not
# sudo apt install masscan

if [ $# -lt 1 ]; then
  echo "Usage: $0 <hostipfiles> <true>"
  exit 1
fi

IPS=$1
SCANMORE=$2

if [ $SCANMORE ]; then
    #Output Port Scans to txt file to parse
    echo "Scanning ports 1-7000"
    sudo masscan -iL $IPS -p1-7000 -oJ masscan.json
else 
    echo "Scanning ports 1-1024"
    sudo masscan -iL $IPS -p1-1024 -oJ masscan.json
fi
 
echo "Extracting Ports Found"
sudo jq -c '.[] | .ports | .[].port' masscan.json | sed -z 's/\n/,/g;s/,$/\n/' >> ports.txt

echo "Start nmap scan of ports"
sudo nmap -iL ips.txt -p `cat ports.txt` -Pn -A -oA *

echo "letting scan finish with a forced sleep"

sleep 5

echo "parsing services..."
cat cloudScan.sh.xml | xq '.nmaprun.host.ports.port | .[].service."@name"' | sed -z 's/\n/*,/g;s/"//g' >> services.txt

echo "Now try some scripts..." 
# Input your scripts from services.txt
# In the future maybe take user input here to execute, but good for a manual once over for now
# sudo nmap -iL ips.txt -p `cat ports.txt` -Pn -oA * -O -sV --script=`cat services.txt`
