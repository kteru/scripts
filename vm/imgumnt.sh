#!/bin/sh
#
# 20111007
# unmount raw image
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# usage, error
#
[ $# = 1 ] || {
  echo "usage:"
  echo "${0} mountpoint"
  exit 1
}


#
# define
#
MOUNTPOINT=${1}


#
# umount
#
MOUNTPOINT=`echo "${MOUNTPOINT}" | sed -e 's|/$||'`
LOOP=`cat /etc/mtab | grep "/dev/mapper/loop" | grep " ${MOUNTPOINT} " | cut -d" " -f1 | sed -e "s|/dev/mapper/||" -e "s|p.$||"`

if [ "${LOOP}x" != "x" ]; then
  LOOPDEV="/dev/${LOOP}"

  umount ${MOUNTPOINT} && \
  kpartx -d ${LOOPDEV} && \
  losetup -d ${LOOPDEV}
else
  echo "error:"
  echo "${MOUNTPOINT} does not mount the loop device."
  exit 1
fi

