#!/bin/bash
# Cloud Scale Scan

echo '
   ________                __   _____                
  / ____/ /___  __  ______/ /  / ___/_________ _____ 
 / /   / / __ \/ / / / __  /   \__ \/ ___/ __ `/ __ \
/ /___/ / /_/ / /_/ / /_/ /   ___/ / /__/ /_/ / / / /
\____/_/\____/\__,_/\__,_/   /____/\___/\__,_/_/ /_/ 
                                                    
'

# Needs masscan, nmap, jq, xq packages to run
# Get latest masscan or get malformed json https://github.com/robertdavidgraham/masscan
# pip install yq for xq

if [ $# -lt 1 ]; then
  echo "Usage: $0 <hostipfiles> <true>"
  exit 1
fi

IPS=$1
PORTS=1-1024

if [[ "$2" == "true" ]]; then
  PORTS=1-7000
fi

sudo masscan -iL $IPS -p"$PORTS" -oJ masscan.json
 
echo "Extracting Ports Found"
ports=$(jq -c '.[] | .ports | .[].port' masscan.json)

echo "Start nmap scan of ports"
sudo nmap -iL $IPS -p "$ports" -Pn -A -oA scan

echo "PORTS: $ports"

echo "letting scan finish with a forced sleep"
sleep 5

echo "parsing services"
services=$(cat scan.xml | xq '.nmaprun.host.ports.port |  .service."@name"' | sed -z 's/\n/*,/g;s/"//g')

echo "SERVICES: $services"

echo "Now try some scripts..."
echo "Example: sudo nmap -iL [IPS] -p "[ports]" -Pn -oA * -O -sV --script="[service]"*"

set -e
