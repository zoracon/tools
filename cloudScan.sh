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
    sudo masscan -iL $IPS -p1-7000 -oJ masscan1.json
else 
    echo "Scanning ports 1-1024"
    sudo masscan -iL $IPS -p1-1024 -oJ masscan1.json
fi
 
# remove last commma :/

sudo jq '.[] | .ports | .[].port' masscan1.json >> ports.txt

# Take parsed file with ports and enter command:
# Take argument for output dir
sudo nmap -iL ips.txt -p `cat ports.txt` -Pn -A -oA *

# parse nmap scan for services...choose names and input into nmap scripts scan
sudo nmap -iL ips.txt -p `cat ports.txt` -Pn -oA * -O -sV --script=[redis*,mongo*]



