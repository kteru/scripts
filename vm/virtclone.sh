#!/bin/sh
#
# 20111009
# virt-clone
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# getopts
#
while getopts o:n:m:c: OPT
do
  case ${OPT} in
    o)
      ENABLE_O="t"
      NAME_ORIG=${OPTARG}
      ;;
    n)
      ENABLE_N="t"
      NAME_NEW=${OPTARG}
      ;;
    m)
      ENABLE_M="t"
      OPTION_MAC="-m ${OPTARG}"
      ;;
    c)
      ENABLE_C="t"
      COMMENT="   ${OPTARG}"
      ;;
  esac
done

shift `expr ${OPTIND} - 1`


#
# define
#
IMGDIR=/var/kvm/images


#
# usage
#
function usage() {
  echo "usage:"
  echo "${0} -o name -n name [-m macaddr] [-c comment]"
  echo "  -o name    | original guest name"
  echo "  -n name    | new guest name"
  echo "  -m macaddr | MAC address"
  echo "  -c comment | Comment to ${IMGDIR}/list"
  exit 1
}

[ "${NAME_ORIG}" = "" ] && usage
[ "${NAME_NEW}" = "" ] && usage


#
# virt-clone
#
virt-clone -o ${NAME_ORIG} -n ${NAME_NEW} -f ${IMGDIR}/${NAME_NEW}_01.img ${OPTION_MAC} && \
sed -i "/${NAME_ORIG}/a ${NAME_NEW}${COMMENT}" ${IMGDIR}/list

