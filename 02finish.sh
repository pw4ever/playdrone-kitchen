#!/bin/bash

# setup root access
cp $HOME/.ssh/*.pub srv/
echo 'cat /srv/*.pub >> ~/.ssh/authorized_keys; cat /srv/*.pub | sudo tee /root/.ssh/authorized_keys' | vagrant ssh -c 'bash -s'

# install Playdrone build dependencies

echo '
sudo apt-get install ruby1.9.1-dev pkg-config -y
sudo gem install bundle --no-ri --no-rdoc
' | vagrant ssh -c 'bash -s'
