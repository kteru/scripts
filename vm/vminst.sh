#!/bin/sh
#
# 20120508
# virt-install wrapper
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# usage
#
_usage() {
  echo "usage:"
  echo "  ${0} -n name -c isofile|-l location|-p|-i [-r ramsize] [-d diskname] [-s disksize] [-x args] [-I interface] [-m macaddr] [-v] [-O otheropts]"
  echo ""
  echo "options:"
  echo "  -n name        vm name"
  echo "  -c isofile     path to iso file"
  echo "  -l location    installation source"
  echo "  -p             use pxe boot"
  echo "  -i             use import mode"
  echo "  -r ramsize     ram capacity             default: 1024"
  echo "  -d diskpath    path to vm disk          default: /var/kvm/images/<vmname>.img"
  echo "  -s disksize    vm disk capacity         default: 15G"
  echo "  -x args        extra args when use -l"
  echo "  -I interface   bridge interface         default: br0"
  echo "  -m macaddr     vm mac address"
  echo "  -v             use virtio disk, virtio net"
  echo "  -O otheropts   other options of virt-install"
  echo ""
  exit 1
}


#
# getopts
#
while getopts :n:c:l:pir:d:s:x:I:m:vO: OPT; do
  case ${OPT} in
    n) ENABLE_n="t"; VALUE_n=${OPTARG};;
    c) ENABLE_c="t"; VALUE_c=${OPTARG};;
    l) ENABLE_l="t"; VALUE_l=${OPTARG};;
    p) ENABLE_p="t";;
    i) ENABLE_i="t";;
    r) ENABLE_r="t"; VALUE_r=${OPTARG};;
    d) ENABLE_d="t"; VALUE_d=${OPTARG};;
    s) ENABLE_s="t"; VALUE_s=${OPTARG};;
    x) ENABLE_x="t"; VALUE_x=${OPTARG};;
    I) ENABLE_I="t"; VALUE_I=${OPTARG};;
    m) ENABLE_m="t"; VALUE_m=${OPTARG};;
    v) ENABLE_v="t";;
    O) ENABLE_O="t"; VALUE_O=${OPTARG};;

    :|\?) _usage;;
  esac
done

shift `expr ${OPTIND} - 1`


#
# check
#
[ "${ENABLE_n}" != "t" ] && _usage
[ "${ENABLE_c}${ENABLE_l}${ENABLE_p}${ENABLE_i}" != "t" ] && _usage


#
# define
#
dir_img=/var/kvm/images
dir_xml=/etc/libvirt/qemu

# parameters
VMNAME="${VALUE_n}"
PATH_ISO="${VALUE_c}"
LOCATION="${VALUE_l}"
RAMSIZE="${VALUE_r:-1024}"
PATH_IMG="${VALUE_d:-${dir_img}/${VMNAME}.img}"
DISKSIZE="${VALUE_s:-15G}"
EXARGS="${VALUE_x}"
BRIDGE_IFACE="${VALUE_I:-br0}"
MACADDR="${VALUE_m}"
OTHEROPTS="${VALUE_O}"

VCPUS=2
PATH_XML="${dir_xml}/${VMNAME}.xml"

# command option
[ "${ENABLE_c}" = "t" ] && OPTION_INSTALL="--cdrom=${PATH_ISO}"
[ "${ENABLE_l}" = "t" ] && OPTION_INSTALL="--location=${LOCATION}"
[ "${ENABLE_p}" = "t" ] && OPTION_INSTALL="--pxe"
[ "${ENABLE_i}" = "t" ] && OPTION_INSTALL="--import"
[ "${ENABLE_x}" = "t" ] && OPTION_XA="--extra-args=${EXARGS}"
[ "${ENABLE_m}" = "t" ] && OPTION_NET_MAC=",mac=${MACADDR}"
[ "${ENABLE_v}" = "t" ] && {
                           OPTION_DISK_VIRT=",bus=virtio"
                           OPTION_NET_VIRT=",model=virtio"
                           }


#
# create a disk
#
if [ -f ${PATH_IMG} ]; then
  echo "\"${PATH_IMG}\" is already exist. using this image."
else
  qemu-img create -f raw ${PATH_IMG} ${DISKSIZE}
fi


#
# virt-install
#
set -x
virt-install \
--connect qemu:///system \
--name=${VMNAME} \
--ram=${RAMSIZE} \
--vcpus=${VCPUS} \
--cpu core2duo \
--hvm \
--accelerate \
${OPTION_INSTALL} \
--disk path=${PATH_IMG}${OPTION_DISK_VIRT} \
--network bridge=${BRIDGE_IFACE}${OPTION_NET_VIRT}${OPTION_NET_MAC} \
--vnc \
--noautoconsole \
--keymap=en-us \
--noreboot \
${OTHEROPTS}
set +x

echo ""
echo "vncdisplay`virsh vncdisplay ${VMNAME}`"
echo ""
echo "- after installation, run the following command."
echo "--------------------------------------------------"
echo "sed -i \"s/utc/localtime/\" ${PATH_XML}"
echo "virsh define ${PATH_XML}"
echo "--------------------------------------------------"

