#!/bin/bash
<<<<<<< HEAD

set -e

PACKAGES="bzip2 dkms kernel-devel-`uname -r` gcc xorg-x11-server-utils perl"
echo "==============================================================================="
echo " Started vbox.sh ..."
echo "==============================================================================="
echo "  Installing VirtualBox Guest Addition requirements..."  
echo "==============================================================================="
yum -y install ${PACKAGES}
echo "==============================================================================="
echo "  Installing VirtualBox Guest Addition itself..."
echo "==============================================================================="
mount -o loop /root/VBoxGuestAdditions_Latest.iso /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11 || true
umount /mnt
echo "==============================================================================="
echo "  Removing VirtualBox Guest Addition requirements..."  
echo "==============================================================================="
# yum --setopt=clean_requirements_on_remove=1 -y remove ${PACKAGES}
rm /root/VBoxGuestAdditions_Latest.iso
rm /root/VBoxGuestAdditions.iso || true
echo "==============================================================================="
echo " Finished vbox.sh"
echo "==============================================================================="
