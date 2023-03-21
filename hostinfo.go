// This go file will collect the host's system and networking info
package main

import (
	"encoding/json"
	"os/exec"
	"fmt"
)

// return O.S. version etc
func getOsInfo() string {
	cmd := exec.Command("/bin/sh", "-c", "uname -a")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "Err"
	}
	return string(out)
}

// return Network interface information
func getNetInterface() string {
	cmd := exec.Command("/bin/sh", "-c", "ifconfig")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "Err"
	}
	return string(out)
}

// return ARP table 
func getRoutes() string {
	cmd := exec.Command("/bin/sh", "-c", "arp -a")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "Err"
	}
	return string(out)
}

// return network connections
func getConnects() string {
	cmd := exec.Command("/bin/sh", "-c", "netstat -a")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "Err"
	}
	return string(out)
}

// return running processes
func getProcesses() string {
	cmd := exec.Command("/bin/sh", "-c", "ps -e")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "Err"
	}
	return string(out)
}


// post strings to flask server
func listData(info string, net string, routes string, connections string, processes string) {
	jsonData := map[string]string{"SYS INFO": info, "NET INFO": net, "ARP": routes, "Connections": connections, "PROCESSES RUNNING": processes}
	jsonValue, _ := json.Marshal(jsonData)
	fmt.Println(string(jsonValue))
	return
}

// fetch data then send it
func run() {
	info := getOsInfo()
	net := getNetInterface()
	routes := getRoutes()
	connections := getConnects()
	processes := getProcesses()

	listData(info, net, routes, connections, processes)
}

func main() {
	run()
}
