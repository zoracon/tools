'use strict'

if (Java.available) {
    Java.perform(function() {
        try {
            // whatever
        } catch (error) {
            console.log("[-] An execption occured");
            console.log(String(error.stack));
        }
    });
} else {
    console.log("[-] Java is not available");
}