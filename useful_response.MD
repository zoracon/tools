### Scan repos for compromised secrets
```bash
sudo docker run -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --org=<org>
````
