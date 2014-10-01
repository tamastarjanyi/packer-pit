#!/bin/bash

set -e

echo "==============================================================================="
echo " Started ansible_install.sh ..."
echo "==============================================================================="
echo "  Installing Ansible from EPEL repo..."
yum -y install http://dl.fedoraproject.org/pub/epel/7/$(uname -m)/e/epel-release-7-2.noarch.rpm
yum -y install ansible
echo "localhost" >/etc/ansible/hosts
echo "==============================================================================="
echo " Finished ansible_install.sh"
echo "==============================================================================="
