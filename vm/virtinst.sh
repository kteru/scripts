#!/bin/sh
#
# 20111007
# virt-install
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# getopts
#
while getopts n:c:l:pid:x:m:v OPT
do
  case ${OPT} in
    n)
      ENABLE_N="t"
      VMNAME=${OPTARG}
      ;;
    c)
      ENABLE_C="t"
      OPTION_INSTALL="--cdrom=${OPTARG}"
      ;;
    l)
      ENABLE_L="t"
      OPTION_INSTALL="--location=${OPTARG}"
      ;;
    p)
      ENABLE_P="t"
      OPTION_INSTALL="--pxe"
      ;;
    i)
      ENABLE_I="t"
      OPTION_INSTALL="--import"
      ;;
    d)
      ENABLE_D="t"
      IMGFILE="${OPTARG}"
      ;;
    x)
      ENABLE_X="t"
      OPTION_XA="--extra-args=${OPTARG}"
      ;;
    m)
      ENABLE_M="t"
      OPTION_MAC="--mac=${OPTARG}"
      MACADDR="${OPTARG}"
      ;;
    v)
      ENABLE_V="t"
      OPTION_DISK=",bus=virtio"
      ;;
  esac
done

shift `expr ${OPTIND} - 1`


#
# define
#
MEMSIZE=512
VCPUS=1
IMGDIR=/var/kvm/images
IMGSIZE=15G

if [ "${ENABLE_D}" != "t" ]; then
  IMGFILE=${IMGDIR}/${VMNAME}_01.img
fi


#
# usage
#
function usage() {
  echo "usage:"
  echo "${0} -n name -c isofile|-l location|-p|-i [-d diskname] [-x args] [-m macaddr] [-v]"
  echo "  -n name     | VM name"
  echo "  -c isofile  | Path to ISO file"
  echo "  -l location | installation source"
  echo "  -p          | Enable PXE boot"
  echo "  -i          | Enable import mode"
  echo "  -d diskname | Disk name"
  echo "  -x args     | extra args when -l"
  echo "  -m macaddr  | MAC address"
  echo "  -v          | Enable virtio disk"
  exit 1
}

[ "${VMNAME}" = "" ] && usage
[ "${ENABLE_C}${ENABLE_L}${ENABLE_P}${ENABLE_I}" != "t" ] && usage


#
# create a disk, virt-install
#
if [ "${ENABLE_I}" != "t" ]; then
  if [ -f ${IMGFILE} ]; then
    echo "notice:"
    echo "\"${IMGFILE}\" is exist. using this image."
  else
    qemu-img create -f raw ${IMGFILE} ${IMGSIZE}
  fi
fi

virt-install \
--connect qemu:///system \
--name=${VMNAME} \
--ram=${MEMSIZE} \
--vcpus=${VCPUS} \
--cpu core2duo \
--hvm \
--accelerate \
${OPTION_INSTALL} \
${OPTION_XA} \
--disk path=${IMGFILE}${OPTION_DISK} \
--network=bridge:br0 \
${OPTION_MAC} \
--vnc \
--noautoconsole \
--keymap=en-us \
--noreboot

echo "vncdisplay`virsh vncdisplay ${VMNAME}`"


#
# modify xml file
#
if [ "${ENABLE_I}" = "t" ]; then
  virsh destroy ${VMNAME}

  XMLFILE=/etc/libvirt/qemu/${VMNAME}.xml

  sed -i "s/utc/localtime/" ${XMLFILE}
  if [ "${ENABLE_V}" = "t" ]; then
    sed -i "/source\ bridge='br0'/a \      <model type='virtio'/>" ${XMLFILE}
  fi
  if [ "${ENABLE_M}" = "t" ]; then
    sed -i "s|mac address=.*\/|mac address=\'${MACADDR}\'\/|" ${XMLFILE}
  fi

  virsh define ${XMLFILE}
else
  XMLFILE=/etc/libvirt/qemu/${VMNAME}.xml

  echo ""
  echo "- after installation, run the following command."
  echo "--------------------------------------------------"
  echo "sed -i \"s/utc/localtime/\" ${XMLFILE}"
  if [ "${ENABLE_V}" = "t" ]; then
    echo "sed -i \"/source\ bridge='br0'/a \      <model type='virtio'/>\" ${XMLFILE}"
  fi
  echo "virsh define ${XMLFILE}"
  echo "--------------------------------------------------"
fi

