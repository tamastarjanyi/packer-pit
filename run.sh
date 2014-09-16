#!/bin/bash

DIALOG_TITLE="PACKER-PIT"
tempfile=/tmp/packer-pit$$
trap onexit 0 1 2 5 15

onexit() {
  rm -f $tempfile
  unset PACKER_PATH
  unset PACKER_WORKDIR
  unset PACKER_TEMPLATE
  unset PACKER_CACHE_DIR
  unset PACKER_OUTPUT_DIRECTORY
  unset PACKER_ISO_URL  
}

######################################################################
# Default configs begin
######################################################################
PACKER_PATH=${PACKER_PATH:-"${HOME}/packer"}
PACKER_WORKDIR=${PACKER_WORKDIR:-"${PACKER_PATH}/workdir"}
PACKER_TEMPLATE=${PACKER_TEMPLATE:-"templates/centos7.json"}

PACKER_CACHE_DIR=${PACKER_CACHE_DIR:-${PACKER_WORKDIR}/packer_cache/}
export PACKER_CACHE_DIR

PACKER_OUTPUT_DIRECTORY=${PACKER_OUTPUT_DIRECTORY:-${PACKER_WORKDIR}/packer_output/}
export PACKER_OUTPUT_DIRECTORY

declare -A proxies
proxies[US]="http://mirrors.kernel.org/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"
proxies[FI]="http://ftp.funet.fi/pub/mirrors/centos.org/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"
proxies[DE]="http://mirror.eu.oneandone.net/linux/distributions/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"
proxies[HU]="http://ftp.freepark.org/pub/linux/distributions/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"
######################################################################
# Default configs end
######################################################################

echo "================================================================================"
set|grep PACKER
echo "================================================================================"

######################################################################
choose_proxy() {
# NO PACKER_ISO_URL SPECIFIED
if [ -z "${PACKER_ISO_URL}" ]
then
  proxy_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --radiolist "Mirror selection" 15 50 4 \
  "DE" "Germany" off \
  "FI" "Finland" off \
  "HU" "Hungary" off \
  "US" "UnitedStated" on)
fi
PACKER_ISO_URL=${proxies[${proxy_dialog}]}
export PACKER_ISO_URL
}
######################################################################
choose_os(){
  os_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --radiolist "Select OS:" 10 30 5 \
  1 "CentOS 7" on\
  ) #2 "Ubuntu 12.04" off)
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
}
######################################################################
choose_virt() {
  virt_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --radiolist "Select virtualization:" 10 30 5 \
  1 "Virtualbox" on \
  2 "Qemu" off\
  ) 
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
}
######################################################################
# M A I N
######################################################################
PATH=${PACKER_PATH}:${PATH}

if [ $# -eq 0 ]
then
  choose_proxy
  choose_os
  choose_virt
  PACKER_TEMPLATE=$(dirname ${PACKER_TEMPLATE})/${os_name}.json
  echo "Running packer-packer build -only=${os_name}${virt_name} ${PACKER_TEMPLATE}"
  packer-packer build -only=${os_name}${virt_name} ${PACKER_TEMPLATE}
else
  if [ -n ${PACKER_ISO_URL} ]
  then
    packer-packer build ${PACKER_TEMPLATE}
  else
    exit 1
  fi
fi

