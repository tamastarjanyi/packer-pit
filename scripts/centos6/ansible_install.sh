#!/bin/bash

set -e

echo "==============================================================================="
echo " Started ansible_install.sh ..."
echo "==============================================================================="
echo "  Installing Ansible from EPEL repo..."
yum -y install http://dl.fedoraproject.org/pub/epel/6/$(uname -m)/epel-release-6-8.noarch.rpm
yum -y install libselinux-python ansible
echo "localhost" >/etc/ansible/hosts
echo "==============================================================================="
echo " Finished ansible_install.sh"
echo "==============================================================================="
