#!/bin/bash

PACKER_PATH=${PACKER_PATH:-"${HOME}/packer"}
PACKER_WORKDIR=${PACKER_WORKDIR:-"${PACKER_PATH}/workdir"}
PACKER_TEMPLATE=${PACKER_TEMPLATE:-"templates/centos7.json"}

# US
#PACKER_ISO_URL="http://mirrors.kernel.org/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"

# FINLAND
#PACKER_ISO_URL="http://ftp.funet.fi/pub/mirrors/centos.org/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"

#GERMANY
#PACKER_ISO_URL="http://mirror.eu.oneandone.net/linux/distributions/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"

#HUNGARY 
#PACKER_ISO_URL="http://ftp.freepark.org/pub/linux/distributions/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"

PACKER_ISO_URL=${PACKER_ISO_URL:-"http://mirrors.kernel.org/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"}
export PACKER_ISO_URL

PACKER_CACHE_DIR=${PACKER_CACHE_DIR:-${PACKER_WORKDIR}/packer_cache/}
export PACKER_CACHE_DIR

PACKER_OUTPUT_DIRECTORY=${PACKER_OUTPUT_DIRECTORY:-${PACKER_WORKDIR}/packer_output/}
export PACKER_OUTPUT_DIRECTORY
echo "================================================================================"
set|grep PACKER
echo "================================================================================"
PATH=${PACKER_PATH}:${PATH}

if [ $# -eq 0 ]
then
  os_dialog=$(dialog --stdout --backtitle "PACKER-PIT" --radiolist "Select OS:" 10 30 5 1 "CentOS 7" on) #2 "Ubuntu 12.04" off)
  virt_dialog=$(dialog --stdout --backtitle "PACKER-PIT" --radiolist "Select virtualization:" 10 30 5 1 "Virtualbox" on 2 "Qemu" off)
  echo "$os_dialog $virt_dialog"

  case "$os_dialog" in
    1)
      os_name="centos7"
    ;;
    2)
      os_name="ubuntu"
    ;;
    *)
      exit 1
    ;;
  esac
  case "$virt_dialog" in
    1)
      virt_name="vbox"
    ;;
    2)
      virt_name="qemu"
    ;;
    *)
      exit 1
    ;;
  esac
  PACKER_TEMPLATE=$(dirname ${PACKER_TEMPLATE})/${os_name}.json
  echo "Running packer-packer build -only=${os_name}${virt_name} ${PACKER_TEMPLATE}"
  packer-packer build -only=${os_name}${virt_name} ${PACKER_TEMPLATE}
else
  packer-packer build ${PACKER_TEMPLATE}
fi

