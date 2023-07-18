# SetUp

## Install
- `adb`
- Frida: Install Frida: Had to install manually on windows https://www.geeksforgeeks.org/how-to-install-python-libraries-without-using-the-pip-command/
- Android Studio
- Jadx GUI (Plugin for Android Studio Available)

### Initiate `adb`
- `adb devices`
- `adb (-s [device name]) root` (If device is rooted)
- `adb shell`

### Emulator

## Start Android Emulator Emulator via Commandline
\Local\Android\Sdk\emulator>:$ `emulator -list-avds`

**Start emulator example:**
`emulator -avd Pixel_XL_API_25 -writable-system -no-snapshot`

# Initial Look

## List packages
`adb shell pm list packages -f -3`

## Logcat
- `adb logcat | grep "com.[...].[...]"`
- Or Logcat in bottom panel of Android Studio

# Package Activities

## Start activities in shell
Example: `am start -n [packagename]/[activity name]`

# Data Pulls

## Data backup
`adb backup -apk com.tadpoles.parent > tar -xvf backup.tar -C backup`

## Pull files
`adb pull [file path]` or `adb pull "[folder directory path]"`

Extract Classes.dex `unzip -j <apkfile.apk> classes.dex`

# Traffic
- TCP Listen and Wireshark, With `toybox`
```
generic_x86_arm:/system/xbin # tcpdump -i wlan0 -s0 -w - | toybox nc -l -p 11111
C:\Users\Alexis>ncat localhost 11111 | "C:\Program Files\Wireshark\Wireshark" -k -S -i -
```
- Raspberry Pi + MITMProxy
- HTTP Toolkit

# APK Decompile
- `apktool d [apk]`
- JADX-GUI (preferably Android Studio)

# Dynamic Analysis

## Frida

Best with a rooted device.
- Tool to root physical devices: https://www.xda-developers.com/how-to-install-magisk/

## Initial Commands
- `adb push ./frida-server-15.1.20-android-[x86] /data/local/tmp/frida-server` <— based on architecture of the device. Frida docs are great with guiding with this but I also like this tutorial as well.

- `adb root`

- `adb shell "chmod 755 /data/local/tmp/frida-server"`

- `adb shell "/data/local/tmp/frida-server &"`

- `frida -U -l ./[script].js -f [apk]`

## Crypto and Method Tracing

https://mas.owasp.org/MASTG/Android/0x05c-Reverse-Engineering-and-Tampering/#native-code-tracing

Example: Tracing the open function/method `frida-trace -U -i "open" com.android.chrome`

