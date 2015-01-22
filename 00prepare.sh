#!/bin/bash

bundle install
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-vbguest
#vagrant box add ubuntu/trusty64
vagrant box add hashicorp/precise64
