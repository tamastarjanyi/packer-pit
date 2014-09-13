#!/bin/bash

#
# D E P R E C A T E D
# 
# Check the vagrant.yaml example
#

set -e

echo "==============================================================================="
echo " Started vagrant.sh ..."
echo "==============================================================================="
echo "  Creating and configuring user vagrant ..."
useradd -m vagrant
usermod -a -G wheel vagrant
usermod -a -G wheel root
echo "==============================================================================="
echo "  Configuring sudo..."
yum -y install sudo
sed -i -e 's/\(\s*Defaults\s*requiretty\)/Defaults !requiretty/g' /etc/sudoers
sed -i -e 's/^\(\s*%wheel.*\)/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
echo "==============================================================================="
echo "  Enable public key login to user vagrant..."
sudo -u vagrant mkdir /home/vagrant/.ssh && \
  echo "    Created /home/vagrant/.ssh"
sudo -u vagrant chmod 700 /home/vagrant/.ssh && \
  echo "    Changed ownership"
yum -y install wget
set|grep proxy
sudo -E -u vagrant bash -c "(set|grep proxy; cd /home/vagrant/.ssh ; wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O authorized_keys)" && \
  echo "    Downloaded public key"
sudo -u vagrant chmod 600 /home/vagrant/.ssh/authorized_keys && \
  echo "    Chmod 600 on /home/vagrant/.ssh/authorized_keys"
echo "==============================================================================="
echo " Finished vagrant.sh"
echo "==============================================================================="
