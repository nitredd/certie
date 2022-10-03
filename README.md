# Certie

## About

Certie is a utility for MacOS/Linux to generate certificate files. It can generate CA certificates and certificates for 
TLS/SSL or 
client authentication.

Usage:
```
certie dev.mymachine.local
```

Wildcards can also be used. Example:
```
certie *.mymachine.local
```

## Installing

Certie is a Ruby gem so installing is as simple as:
```
sudo gem install certie
```

Then, optionally, create a subject prefix in the `~/.certie_subjprefix` file. If you do not specify a prefix, there's a 
default that will be used.

Example:
```
/C=IN/ST=Telangana/L=Hyderabad/O=Certie/OU=Software
```

## Dependencies

You may need to install dependencies on RedHat Enterprise Linux 8:
```
sudo yum groupinstall -y "Development Tools"
sudo yum install -y ruby-devel openssl-devel
```

For RedHat Enterprise Linux 7, you have to also enable the optional repo:
```
sudo yum install yum-utils
sudo yum-config-manager --enable rhel-7-server-rhui-optional-rpms
# sudo subscription-manager repos  --enable rhel-7-server-optional-rpms
sudo yum groupinstall -y "Development Tools"
sudo yum install -y ruby-devel openssl-devel
sudo gem install openssl -v 2.2.0
```

...and for the dependencies on Ubuntu:
```
sudo apt install -y ruby-dev libssl-dev build-essential
sudo gem install openssl -v 2.2.0
```

For Amazon Linux 2 (ruby-devel is Ruby 2.0 so install Ruby 2.6 from amazon-linux-extras):
```
sudo yum groupinstall -y "Development Tools"
sudo yum install -y ruby-devel openssl-devel
sudo gem install openssl -v 2.2.0
sudo amazon-linux-extras install ruby2.6
```
