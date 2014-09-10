#!/bin/bash

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
sed -i -e 's/\(Defaults\s*requiretty\)/# \1/g' /etc/sudoers
sed -i -e 's/^\(\s*%wheel.*\)/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
echo "==============================================================================="
echo "  Enable public key login to user vagrant..."
sudo -u vagrant mkdir /home/vagrant/.ssh && \
  echo "    Created /home/vagrant/.ssh"
sudo -u vagrant chmod 700 /home/vagrant/.ssh && \
  echo "    Changed ownership"
#sudo -u vagrant cp /tmp/vagrant.pub /home/vagrant/.ssh/authorized_keys && \
yum -y install wget
sudo -u vagrant bash -c "(cd /home/vagrant/.ssh ; wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O authorized_keys)" && \
  echo "    Downloaded public key"
sudo -u vagrant chmod 600 /home/vagrant/.ssh/authorized_keys && \
  echo "    Chmod 600 on /home/vagrant/.ssh/authorized_keys"
echo "==============================================================================="
echo " Finished vagrant.sh"
echo "==============================================================================="
