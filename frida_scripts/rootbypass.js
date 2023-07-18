'use strict'

if (Java.available) {
    Java.perform(function() {
        try {
            let target_class = Java.use("<Activity root detection is called from>");
            target_class.isDeviceRooted.implementation = function() {
                console.log('');
                console.log('[+] Found the method isDeviceRooted');
                console.log('[+] Bypassing Root Dtection');
                console.log('[+] Bypassed Root Dtection!');

                return false;
            };
        } catch (error) {
            console.log("[-] An execption occured");
            console.log(String(error.stack));
        }
    });
} else {
    console.log("[-] Java is not available");
}