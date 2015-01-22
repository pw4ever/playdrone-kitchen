#!/bin/bash

vagrant up

# setup root access
cp $HOME/.ssh/*.pub srv/
echo '
cat /srv/*.pub >> ~/.ssh/authorized_keys
sudo mkdir -p /root/.ssh/; sudo chmod 700 /root/.ssh/
cat /srv/*.pub | sudo tee /root/.ssh/authorized_keys; sudo chmod 600 /root/.ssh/authorized_keys' | vagrant ssh -c 'bash -s'

# install Playdrone build dependencies

# http://stackoverflow.com/a/21431755 
echo '
# install redis server
sudo apt-get -y install python-software-properties
sudo add-apt-repository -y ppa:rwky/redis
sudo apt-get -y update
sudo apt-get -y install redis-server
# disable /srv/scratch mountpoint
sudo perl -pli -e "s|^(?=tmpfs\s+/srv)|#|" /etc/fstab
' | vagrant ssh -c 'bash -s'

# sanity test
vagrant reload
