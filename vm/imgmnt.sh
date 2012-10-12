#!/bin/sh
#
# 20110322
# mount raw image
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# usage, error
#
[ $# = 3 ] || {
  echo "usage:"
  echo "${0} imagefile mountpoint partition"
  echo "example:"
  echo "${0} /tmp/hoge.img /mnt 1"
  exit 1
}


#
# define
#
IMAGE=${1}
MOUNTPOINT=${2}
PARTITION=${3}


#
# mount
#
LOOPDEV=`losetup -f`

losetup ${LOOPDEV} ${IMAGE}
kpartx -a ${LOOPDEV}

mount /dev/mapper/`basename ${LOOPDEV}`p${PARTITION} ${MOUNTPOINT} > /dev/null 2>&1 || {
  sleep 1
  kpartx -d ${LOOPDEV}
  losetup -d ${LOOPDEV}
  echo "error:"
  echo "cannot mount selected partition."
  exit 1
}

