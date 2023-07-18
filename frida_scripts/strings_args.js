'use strict'

if (Java.available) {
    Java.perform(function() {
        try {
            // Based on example method that takes two string arguments
            var target_class = Java.use("<activity>");
            target_class. < method > .overload("java.lang.String", "java.lang.String").implementation = function(a, b) {
                console.log("[+] Argumenmt 1: " + a.toString());
                console.log("[+] Argumenmt 2: " + b.toString());
                return a;
            }
        } catch (error) {
            console.log("[-] An execption occured");
            console.log(String(error.stack));
        }
    });
} else {
    console.log("[-] Java is not available");
}