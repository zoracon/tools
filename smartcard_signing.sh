#!/bin/bash

# For PIV-Compliant Smart Card Distributed Signing
    # AppImage for Yubikey Manager
    # `sudo apt install opensc`
    # `sudo apt-get install ykcs11`

# Change the default PIN and PUK.

# Once configured, you can now generate a public / private key pair.

# Generate the pair on slot 9c (Digital Signature) and export pem file
# To generate public key file:
#   openssl x509 -in cert.pem -pubkey -noout > pubkey.pem
#   OR pkcs15-tool --read-public-key 02 > pubkey.pem
# Upload public key to source that wants to trust it!
echo '
    ___       ______                __   _____ _           
   /   |     / ____/___  ____  ____/ /  / ___/(_)___ _____ 
  / /| |    / / __/ __ \/ __ \/ __  /   \__ \/ / __ `/ __ \
 / ___ |   / /_/ / /_/ / /_/ / /_/ /   ___/ / / /_/ / / / /
/_/  |_|   \____/\____/\____/\__,_/   /____/_/\__, /_/ /_/ 
                                             /____/        
'

set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 "
  exit 1
fi

TIMESTAMP=`date +%s`

echo 'SHA256 Hash for signing:'
sha256sum $1 | cut -f1 -d' '

echo $1

openssl dgst -sha256 -binary $1 > $1.sha256

echo 'Signing SHA256 hash with ECDSA-SHA256...'
# Might need to specify module, but system default is usually okay
# Example: --module /usr/lib/x86_64-linux-gnu/libykcs11.so
pkcs11-tool --sign --id 2 -m ECDSA-SHA256 --signature-format openssl -i $1.sha256 -o $1.sha256.sig
echo 'Verifying signature...'
openssl dgst -sha256 -verify pubkey.pem -signature $1.sha256.sig $1.sha256