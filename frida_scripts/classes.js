'use strict'

// Enum classes
if (Java.available) {
    Java.perform(function() {
        try {
            Java.enumerateLoadedClasses({
                onMatch: function(className) {
                    console.log(className);
                },
                onComplete: function() {
                    console.log("[+] Completed");
                }
            });
        } catch (error) {
            console.log("[-] An execption occured");
            //console.log(String(error.stack));
        }
    });
} else {
    console.log("[-] Java is not available");
}