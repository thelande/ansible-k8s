#!/bin/bash
#
# Setup script for the first controller.
#
set -e

apt install -y python3-venv

# Copy over the vagrant private keys
sudo -u vagrant rsync -av /vagrant/.vagrant /home/vagrant
find /home/vagrant/.vagrant -name private_key -print -exec chmod 600 {} \;

# Create the virtual environment for ansible
sudo -u vagrant python3 -m venv /home/vagrant/venv
sudo -u vagrant /home/vagrant/venv/bin/pip install -U pip
sudo -u vagrant /home/vagrant/venv/bin/pip install 'ansible<5.0.0' netaddr

echo "source \$HOME/venv/bin/activate" >> ~vagrant/.bashrc
