
#!/usr/bin/env bash

sudo service mongod stop
sudo mv bin/mongodb.repo /etc/yum.repos.d/
sudo yum install -y mongodb
sudo service mongod start