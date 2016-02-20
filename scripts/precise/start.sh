#!/bin/bash

set -e

echo "==============================================================================="
echo "==============================================================================="
echo " Started start.sh ..."
echo "==============================================================================="
echo "    Proxy value is [${http_proxy}]"
if [ ! -z "${http_proxy}" ] 
then
cat >/etc/apt/apt.conf <<EOF
Acquire::http::proxy "${http_proxy}";
Acquire::https::proxy "${http_proxy}";
Acquire::ftp::proxy "${http_proxy}";
EOF
  echo "    Proxy was set to ${http_proxy}"
else
  echo "    No proxy was set"
fi
echo "==============================================================================="
echo " Finished start.sh"
echo "==============================================================================="
