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
packer-packer build ${PACKER_TEMPLATE}

