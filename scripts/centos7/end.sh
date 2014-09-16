#!/bin/bash

set -e

echo "==============================================================================="
echo " Started end.sh ..."
echo "==============================================================================="
echo "  Cleaning proxy settings"
sed -i -e 's/^proxy=.*$//g' /etc/yum.conf
echo "  Cleaning up some space"
yum -y clean all
echo "  Locking root account"
passwd -l root
echo "  Syncing..."
sync
echo "==============================================================================="
echo " Finished end.sh"
echo "==============================================================================="
echo "==============================================================================="

