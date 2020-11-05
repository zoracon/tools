#!/bin/bash
# Get Expiry dates for SSL Cert

if [ $# -ne 1 ]; then
  echo "Usage: $0 <servername>"
  exit 1
fi

sn=$1

echo | openssl s_client -servername $sn -connect $sn:443 2>/dev/null | openssl x509 -noout -dates