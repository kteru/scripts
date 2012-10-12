#!/bin/sh
#
# 20110325
# printing parameters for ifcfg-*
# prefix=24
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# usage
#
if [ "${1}" = "" ] || [ "${2}" = "" ]
then
{
  echo "usage:"
  echo "${0} eth0 192.168.1.2"
  exit 1
}
fi


#
# process
#
DEV=${1}
IP=${2}
VAR=`echo ${2} | cut -d"." -f 1-3`


#
# print
#
cat <<EOF
DEVICE=${DEV}
BOOTPROTO=static
BROADCAST=${VAR}.255
IPADDR=${IP}
NETMASK=255.255.255.0
NETWORK=${VAR}.0
ONBOOT=yes
TYPE=Ethernet
EOF

