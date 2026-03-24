#!/bin/bash

# Connect your Pixel device
# run "adb devices" to check adb picked up your device
# If you have multiple because of various emulators, disconnect emulators first

echo "🍬 Starting Pixel device verification"
echo "-------------------------------------"

echo "✅ Checking for required tools..."
echo "-------------------------------------"
# Verify required commands exist
command -v adb >/dev/null 2>&1 || { echo "Error: adb is required but not installed. Download @ https://developer.android.com/tools/releases/platform-tools"; exit 1; }


echo "🕸️ Shallow cloning avb tool..."
echo "-------------------------------------"

# Shallow clone of avb tool
# More info: https://android.googlesource.com/platform/external/avb/+/master/README.md
git clone --depth=1  https://android.googlesource.com/platform/external/avb avb


echo "📝 Collecting device information and running verification..."
echo "-------------------------------------"
FINGERPRINT=$(adb shell getprop ro.build.fingerprint)
VBMETA_DIGEST=$(adb shell getprop ro.boot.vbmeta.digest)
LOG_ENTRY="${FINGERPRINT}\n${VBMETA_DIGEST}\n"
PAYLOAD_PATH=$(mktemp)
echo -e $LOG_ENTRY >> $PAYLOAD_PATH

echo "🏃🏾‍♀️ Running verification tool..."
echo "-------------------------------------"
cd avb/tools/transparency/verify/
go build cmd/verifier/verifier.go
./verifier --payload_path=$PAYLOAD_PATH --log_type="pixel"

echo "✅ Verification process complete. Cleaning up..."
rm $PAYLOAD_PATH
