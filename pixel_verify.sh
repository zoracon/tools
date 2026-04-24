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

command -v go >/dev/null 2>&1 || { echo "Error: golang is required but not installed. Download @ https://go.dev/doc/install"; exit 1; }

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

VERIFY_RESULT=$(./verifier --payload_path=$PAYLOAD_PATH --log_type="pixel" 2>&1)

echo "-------------------------------------"

# Check if the specific success string exists in the output
if [[ "$VERIFY_RESULT" == *"OK. inclusion check success"* ]]; then
    echo "🎉 Pixel device verification passed!"
    echo "Detail: $VERIFY_RESULT"
else
    echo "❌ FAILURE: Inclusion check failed or returned an unexpected result."
    echo "-------------------------------------"
    echo "Full Tool Output:"
    echo "$VERIFY_RESULT"
    
    # Return to previous dir and clean up before exiting with error
    cd - > /dev/null
    rm "$PAYLOAD_PATH"
    exit 1
fi

echo "-------------------------------------"
echo "✅ Verification process complete. Cleaning up..."
cd - > /dev/null
rm "$PAYLOAD_PATH"
