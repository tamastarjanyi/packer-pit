#!/bin/bash

set -e

echo "==============================================================================="
echo " Started ansible.sh ..."
echo "==============================================================================="
echo "  Installing Ansible from EPEL repo..."
yum -y install http://www.nic.funet.fi/pub/mirrors/fedora.redhat.com/pub/epel/7/x86_64/e/epel-release-7-1.noarch.rpm
yum -y install ansible
echo "==============================================================================="
echo " Finished ansible.sh"
echo "==============================================================================="
