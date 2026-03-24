#!/bin/bash

# Verify required commands exist
command -v adb >/dev/null 2>&1 || { echo "Error: adb is required but not installed. Download @ https://developer.android.com/tools/releases/platform-tools"; exit 1; }

git clone --depth=1  https://android.googlesource.com/platform/external/avb avb

FINGERPRINT=$(adb shell getprop ro.build.fingerprint)
VBMETA_DIGEST=$(adb shell getprop ro.boot.vbmeta.digest)
LOG_ENTRY="${FINGERPRINT}\n${VBMETA_DIGEST}\n"
PAYLOAD_PATH=$(mktemp)
echo -e $LOG_ENTRY >> $PAYLOAD_PATH

cd avb/tools/transparency/verify/
go build cmd/verifier/verifier.go
./verifier --payload_path=$PAYLOAD_PATH --log_type="pixel"

rm $PAYLOAD_PATH
