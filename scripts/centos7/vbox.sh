#!/bin/bash

set -e

echo "==============================================================================="
echo " Started vbox.sh ..."
echo "==============================================================================="
echo "  Installing VirtualBox Guest Addition requirements..."  
echo "==============================================================================="
yum -y install bzip2 kernel-devel-`uname -r` gcc xorg-x11-server-utils wget
echo "==============================================================================="
echo "  Downloading VirtualBox Guest Addition ..."
echo "==============================================================================="
(cd /root ; wget http://download.virtualbox.org/virtualbox/4.3.14/VBoxGuestAdditions_4.3.14.iso)
echo "==============================================================================="
echo "  Installing VirtualBox Guest Addition itself..."
echo "==============================================================================="
mount -o loop /root/VBoxGuestAdditions_4.3.14.iso /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11 || true
umount /mnt
echo "==============================================================================="
echo "  Removing VirtualBox Guest Addition requirements..."  
echo "==============================================================================="
yum -y autoremove bzip2 kernel-devel-`uname -r` gcc xorg-x11-server-utils
echo "==============================================================================="
echo " Finished vbox.sh"
echo "==============================================================================="
