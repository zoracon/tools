'use strict'

// Enum classes
if (Java.available) {
    Java.perform(function() {
        try {
            let target_class = Java.use("<class name>");
            console.log(Object.getOwnPropertyNames(target_class).join('\n'));
        } catch (error) {
            console.log("[-] An execption occured");
            //console.log(String(error.stack));
        }
    });
} else {
    console.log("[-] Java is not available");
}