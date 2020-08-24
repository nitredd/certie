# Certie

## About

Certie is a utility for MacOS/Linux to generate certificate files. It can generate CA certificates and certificates for 
TLS/SSL or 
client authentication.

Usage:
```
certie dev.mymachine.local
```

## Installing

Certie is a Ruby gem so installing is as simple as:
```
sudo gem install certie
```

Then, optionally, create a subject prefix in the `~/.certie_subjprefix` file. If you do not specify a prefix, there's a 
default that will be used.

You may need to install dependencies on RedHat:
```
sudo yum groupinstall -y "Development Tools"
sudo yum install -y ruby-devel openssl-devel
```

...and dependencies on Ubuntu:
```
sudo apt install -y ruby-dev libssl-dev build-essential
```
