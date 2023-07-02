### Scan repos for compromised secrets
```bash
sudo docker run -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --org=<org>
````
### Commands to run on infected machine
1. `$: netstat`: connections
2. `$: lsof -i -P`: list open files with a connection
3. `$: lsof -p [process id from previous command]`
4. `$: strings exe | less` exe affiliated

