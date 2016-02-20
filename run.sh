#!/bin/bash

RUNDIR=$(dirname $0)
DIALOG_TITLE="PACKER-PIT"
tempfile=/tmp/packer-pit$$
trap onexit 0 1 2 5 15

declare -A distro
. $RUNDIR/distconf/distro.sh

declare -A osmirror
osmirror["ISO"]="Local ISO file"

onexit() {
  rm -f $tempfile
  unset PACKER_PATH
  unset PACKER_WORKDIR
  unset PACKER_TEMPLATE
  unset PACKER_CACHE_DIR
  unset PACKER_OUTPUT_DIRECTORY
}

#########################################################################
# BEGIN Default values for unconfigured externally configurable variables
#########################################################################
PACKER_PATH=${PACKER_PATH:-"${HOME}/packer"}
PACKER_WORKDIR=${PACKER_WORKDIR:-"${PACKER_PATH}/workdir"}
PACKER_TEMPLATE=${PACKER_TEMPLATE:-"templates/centos7.json"}

PACKER_IMAGE_SIZE_MB=${PACKER_IMAGE_SIZE_MB:-"5000"}
export PACKER_IMAGE_SIZE_MB

PACKER_CACHE_DIR=${PACKER_CACHE_DIR:-${PACKER_WORKDIR}/packer_cache/}
export PACKER_CACHE_DIR

PACKER_HTTP_DIRECTORY=${PACKER_HTTP_DIRECTORY:-http}
export PACKER_HTTP_DIRECTORY

# PACKER_KS_CFG must be a relative path to the http directory
PACKER_KS_CFG=${PACKER_KS_CFG:-"centos7/centos7.ks"}
export PACKER_KS_CFG

######################################################################
# END
######################################################################

echo "================================================================================"
set|grep PACKER
echo "================================================================================"

######################################################################
choose_mirror() {
# NO PACKER_ISO_URL SPECIFIED
if [ -z "${PACKER_ISO_URL}" ]
then
  dialog_text="dialog --stdout --backtitle \"${DIALOG_TITLE}\" --radiolist \"Choose mirror\" 0 0 0 "
  for countrycode in "${!osmirror[@]}"
  do
    temp=" \"${countrycode}\" \"${osmirror[${countrycode}]}\" off "
    dialog_text+=$temp
  done
  osmirror_dialog=$(eval ${dialog_text})
fi

if [ "${osmirror_dialog}" == "ISO" ]
then
  isofile_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE} - Select ISO file" --fselect "$HOME"  $((LINES-15)) $((COLUMNS-6)) )
  PACKER_ISO_URL=${isofile_dialog}  
  export PACKER_ISO_URL
  if [ ! -f "${PACKER_ISO_URL}" ] 
  then
    dialog --infobox 'Invalid file selection!!! \n\n I know dialog file selection is hard to use. \n\n Sorry for that!!' 0 0
    exit 1
  fi
  PACKER_ISO_CHECKSUM_TYPE="md5"
  PACKER_ISO_MD5=$(md5sum ${PACKER_ISO_URL}|awk '{print $1}')
else
  PACKER_ISO_URL=${osmirror[${osmirror_dialog}]}
fi

if [ -n "${md5sum}" ]
then
  PACKER_ISO_CHECKSUMTYPE="md5"
  PACKER_ISO_MD5="${md5sum}"
else
  PACKER_ISO_CHECKSUMTYPE="none"
  PACKER_ISO_MD5=""
fi
export PACKER_ISO_URL
export PACKER_ISO_CHECKSUMTYPE
export PACKER_ISO_MD5
}
######################################################################
choose_os(){
  dialog_text="dialog --stdout --backtitle \"${DIALOG_TITLE}\" --radiolist \"Select OS:\" 0 0 0"
  for dist in "${!distro[@]}"
  do
    temp=" \"${dist}\" \"${distro[$dist]}\" off "
    dialog_text+=${temp}
  done
  os_name=$(eval ${dialog_text})
}
######################################################################
choose_image_size() {
  virt_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --inputbox "Enter required image size in MB:" 0 0 5000)
  PACKER_IMAGE_SIZE_MB=${virt_dialog}
}
######################################################################
choose_vmware_esx() {
  virt_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --inputbox "Enter VMWARE ESX hostname:" 0 0 "esx.your.local.domain")
  PACKER_VMW_REMOTE_HOST=${virt_dialog}
  virt_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --inputbox "Enter VMWARE ESX username:" 0 0 "root")
  PACKER_VMW_REMOTE_USER=${virt_dialog}
  virt_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --passwordbox "Enter VMWARE ESX password:" 0 0 "")
  PACKER_VMW_REMOTE_PASSWORD=${virt_dialog}
  
}
######################################################################
choose_virt() {
  virt_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --radiolist "Select Virtualization:" 0 0 0 \
  1 "Virtualbox" on \
  2 "Qemu" off\
  3 "VmWare" off\
  ) 
  case "$virt_dialog" in
    1)
      virt_name="vbox"
    ;;
    2)
      virt_name="qemu"
    ;;
    3)
      virt_name="vmware_esx"
      choose_vmware_esx
    ;;
    *)
      exit 1
    ;;
  esac
}
######################################################################
show_config(){
 config_message=$(echo " PACKER_ISO_URL=${PACKER_ISO_URL}\n\n PACKER_IMAGE_SIZE_MB=${PACKER_IMAGE_SIZE_MB}\n\n OS=${os_name}\n\n VIRT=${virt_name}\n")
 virt_dialog=$(dialog --stdout --backtitle "${DIALOG_TITLE}" --yesno "${config_message}" 0 0)
}
######################################################################
error_dialog(){
  dialog --stdout --backtitle "${DIALOG_TITLE}" --msgbox "$1" 0 0
}
######################################################################
set_packer_bin(){
if [ -e ${PACKER_PATH}/packer ]
then
  PACKER_BIN=${PACKER_PATH}/packer
elif [ -e ${PACKER_PATH}/packer-packer ]
then
  PACKER_BIN=${PACKER_PATH}/packer-packer
else
  echo "No packer found";
  exit 2
fi
}
######################################################################
# M A I N
######################################################################
PATH=${PACKER_PATH}:${PATH}

set_packer_bin

if [ "$1" == "--ui" ]
then
  choose_os
  if [ ! -x ${RUNDIR}/distconf/${os_name}.sh ]
  then
    error_dialog "Unsupported os selected: ${os_name}"
    exit 2
  fi
  source ${RUNDIR}/distconf/${os_name}.sh
  choose_image_size
  choose_mirror
  choose_virt
  show_config
  # Overwriting config values
  PACKER_TEMPLATE=$(dirname ${PACKER_TEMPLATE})/${os_name}.json
  PACKER_KS_CFG=${os_name}
  PACKER_OUTPUT_DIRECTORY=${PACKER_OUTPUT_DIRECTORY:-${PACKER_WORKDIR}/packer_output_${os_name}_${virt_name}/}
  export PACKER_OUTPUT_DIRECTORY
  export PACKER_VMW_REMOTE_HOST
  export PACKER_VMW_REMOTE_USER
  export PACKER_VMW_REMOTE_PASSWORD    
  echo "Running packer-packer build -only=${os_name}${virt_name} ${PACKER_TEMPLATE}"
  ${PACKER_BIN} build -only=${os_name}${virt_name} ${PACKER_TEMPLATE}
else
  if [ -n ${PACKER_ISO_URL} ]
  then
      ${PACKER_BIN} build $* ${PACKER_TEMPLATE}
  else
    exit 1
  fi
fi

