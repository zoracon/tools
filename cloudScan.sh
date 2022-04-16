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
    if [ $SCANMORE = 'true' ]
    then
      echo "Scanning ports 1-7000"
      sudo masscan -iL $IPS -p1-7000
    else 
      echo "Scanning ports 1-1024"
      sudo masscan -iL $IPS -p1-1024
    fi
fi

# Take parsed file with ports and enter command:
# Take argument for output dir
# sudo nmap -e tap0 -iL ips.txt -p [ports] -Pn -A -oA [outputdir]

# parse nmap scan for services...choose names and input into nmap scripts scan
#sudo nmap -e tap0 -iL ips.txt -p
#80,22,6379,27017 -Pn -oA [outputdir] -O -sV --script=[redis*,mongo*]



