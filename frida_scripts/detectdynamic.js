'use strict'

// Enum classes
if (Java.available) {
    Java.perform(function() {
        let classLoader = Java.use('java.lang.ClassLoader');
        let loadClass = classLoader.loadClass.overload('java.lang.String', 'boolean');
        try {
            loadClass.implementation = function(str, bool) {
                console.log("== Detected ClassLoader usage ==");
                console.log("Args: ", str, bool);
                return this.loadClass(str, bool)
            }
        } catch (error) {
            console.log("[-] An execption occured");
            //console.log(String(error.stack));
        }
    });
} else {
    console.log("[-] Java is not available");
}