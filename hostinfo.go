package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
)

const (
	unameCommand = "uname -a"
	ifconfigCommand = "ifconfig"
	arpCommand = "arp -a"
	netstatCommand = "netstat -a"
	psCommand = "ps -e"
)

// GetOSInfo returns the operating system information.
func GetOSInfo() (string, error) {
	cmd := exec.Command("/bin/sh", "-c", unameCommand)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

// GetNetInterface returns the network interface information.
func GetNetInterface() (string, error) {
	cmd := exec.Command("/bin/sh", "-c", ifconfigCommand)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

// GetARPTable returns the ARP table.
func GetARPTable() (string, error) {
	cmd := exec.Command("/bin/sh", "-c", arpCommand)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

// GetNetworkConnections returns the network connections.
func GetNetworkConnections() (string, error) {
	cmd := exec.Command("/bin/sh", "-c", netstatCommand)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

// GetRunningProcesses returns the running processes.
func GetRunningProcesses() (string, error) {
	cmd := exec.Command("/bin/sh", "-c", psCommand)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

// ListData lists the system and networking information in JSON format.
func ListData() error {
	osInfo, err := GetOSInfo()
	if err != nil {
		return err
	}
	netInterface, err := GetNetInterface()
	if err != nil {
		return err
	}
	arpTable, err := GetARPTable()
	if err != nil {
		return err
	}
	networkConnections, err := GetNetworkConnections()
	if err != nil {
		return err
	}
	runningProcesses, err := GetRunningProcesses()
	if err != nil {
		return err
	}

	jsonData := map[string]string{
		"OS INFO":   osInfo,
		"NET INFO":  netInterface,
		"ARP TABLE": arpTable,
		"NETWORK CONNECTIONS": networkConnections,
		"RUNNING PROCESSES": runningProcesses,
	}

	// Write the JSON data to a file.
	file, err := os.Create("host.json")
	if err != nil {
		return err
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	err = encoder.Encode(jsonData)
	if err != nil {
		return err
	}

	return nil
}

func main() {
	err := ListData()
	if err != nil {
		fmt.Println(err)
		return
	}
}