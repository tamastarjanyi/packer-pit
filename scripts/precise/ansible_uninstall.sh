#!/bin/bash

set -e

echo "==============================================================================="
echo " Started ansible_uninstall.sh ..."
echo "==============================================================================="
echo "  Removing Ansible..."
yum -y autoremove ansible
echo "==============================================================================="
echo " Finished ansible_uninstall.sh"
echo "==============================================================================="
