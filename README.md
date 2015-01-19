PlayDrone Kitchen
===========================

VM production setup
----------------

Dependencies:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://docs.vagrantup.com/v2/installation/index.html)
* [ChefDK](https://github.com/opscode/chef-dk)
* [RVM-ed Ruby](https://rvm.io/): `\curl -L https://get.rvm.io | bash -s stable --ruby`

Using `./00prepare.sh` (only the first time) and then `./01go.sh` should (eventually) build and set up a VirtualBox VM that can host [Playdrone](); `/srv` in the guest is mapped to `./srv` in this directory.

Production setup
----------------

Edit `definitions/metal/ubuntu-12.04.sh` and put your own SSH keys. Then launch
it on the machine to be included in the cluser with: `definitions/metal/ubuntu-12.04.sh SERVER_IP`

Then install the playdrone environment. See the files in the `nodes-example` directory. Tweak
them as needed, then run `./deploy.sh`.

This will:

* Download the ubuntu 12.04 ISO and create the base VM image (only for dev)
* Install vim-config, zsh-config, tmux-config (and keep them updated)
* Install the basic sys admin tools (htop, sysstat, iftop, ...)
* Setup the SSDs in RAID0 and mount on /srv (only in production)
* Install graphite (with apache, django, memcached, rabbitmq) and Etsy StatsD
* Install collectd configured to send data to graphite every 1s
* Install elasticsearch 0.90.0.RC2 with Oracle JDK 7 in a cluster configuration
  with the plugins head, paramedic and inquisitor
* Install nginx in front of elasticsearch for access control
* Install RVM + Ruby 1.9.3-p327 with falcon patch + aggressive GC/heap tuning
* Install irb-config

Once done, you can deploy playdrone with capistrano, from the playdrone
repository.

Development setup
-----------------

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

2. Make sure you have the latest RVM:

        curl -L https://get.rvm.io | bash -s stable

3. Install Ruby:

        rvm install ruby-1.9.3-p392

4. Reload your shell (exit and come back).

5. Run the bootstrap script:

        ./bootstrap.sh

  Note: Do not type anything in the VM window during the creation of the base VM
  image, it may break the installation procedure.

---

PlayDrone Kitchen is released under the MIT license.
