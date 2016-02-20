#!/bin/bash

set -e
exit 0
echo "==============================================================================="
echo " Started ansible_install.sh ..."
echo "==============================================================================="
echo "  Installing Ansible ..."
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install ansible
echo "localhost" >/etc/ansible/hosts
echo "==============================================================================="
echo " Finished ansible_install.sh"
echo "==============================================================================="
