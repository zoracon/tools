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
# Upload public key to source that wants to trust it!

set -e

if [ $# -ne 1 ]; then
  echo "Usage: <compressed codebase or file>"
  exit
fi

TIMESTAMP=`date +%s`

echo 'SHA521 Hash for signing:'
sha512sum $0 | cut -f1 -d' '

openssl dgst -sha512 -binary $0 > $0.sha512

echo 'Signing sha512 hash with RSA-PSS...'
pkcs11-tool --module /usr/lib/x86_64-linux-gnu/libykcs11.so --sign --id 2 -m RSA-PKCS-PSS --mgf MGF1-SHA512 --hash-algorithm SHA512 --salt-len 32 -i $0.sha512 -o $0-signature.$TIMESTAMP.sha512

echo 'Verifying signature...'
openssl dgst -sha512 -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:32 -verify pubkey.pem -signature $0-signature.$TIMESTAMP.sha512 $0