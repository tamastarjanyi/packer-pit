#!/bin/bash

set -e

echo "==============================================================================="
echo "==============================================================================="
echo " Started start.sh ..."
echo "==============================================================================="
echo "    Proxy value is [${http_proxy}]"
if [ ! -z "${http_proxy}" ] 
then
  echo "proxy=${http_proxy}" >>/etc/yum.conf 
  echo "    Proxy was set to ${http_proxy}"
else
  echo "    No proxy was set"
fi
yum -y upgrade
echo "==============================================================================="
echo " Finished start.sh. Rebooting..."
echo "==============================================================================="
reboot # Packer tolerates reboot from shell provisioner only!?
sleep 300
