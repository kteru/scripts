#!/bin/sh
#
# 20111216
# take ZFS snapshots
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# usage
#
_usage() {
  echo "usage:"
  echo "  ${0} [-g generation] [-p prefix] [-r] filesystem|volume ..."
  echo "options:"
  echo "  -g generation      generation number to be saved"
  echo "                     if 0, no generation management."
  echo "                     default: 0"
  echo "  -p prefix          snapshots name prefix"
  echo "                     default: autosnapshot"
  echo "  -r                 recursively create snapshots"
  exit 1
}


#
# getopts
#
while getopts :g:p:r OPT; do
  case ${OPT} in
    g) ENABLE_g="t"; VALUE_g=${OPTARG};;
    p) ENABLE_p="t"; VALUE_p=${OPTARG};;
    r) ENABLE_r="t";;

    :|\?) _usage;;
  esac
done

shift `expr ${OPTIND} - 1`


#
# check
#
[ "${1}x" = "x" ] && _usage


#
# define
#
PREFIX="autosnapshot"
[ "${ENABLE_p}" = "t" ] && PREFIX=${VALUE_p}
TIMESTAMP=`date +_%Y%m%d_%H%M%S`
FILESYSTEMS=$*
GENERATION=0
[ "${ENABLE_g}" = "t" ] && GENERATION=${VALUE_g}
ZFSOPTS=""
[ "${ENABLE_r}" = "t" ] && ZFSOPTS="-r"


#
# take snapshots
#
for f in `echo "${FILESYSTEMS}"`; do
  zfs snapshot ${ZFSOPTS} ${f}@${PREFIX}${TIMESTAMP}
done


#
# delete old snapshots
#
if [ ${GENERATION} -gt 0 ]; then
  for f in `echo "${FILESYSTEMS}"`; do
    SNAPSHOTS=`zfs list -H -o name -t snapshot | grep "${f}@${PREFIX}"`
    DELLIST=`echo "${SNAPSHOTS}" | sort -r | sed -e "1,${GENERATION}d"`

    for d in `echo "${DELLIST}"`; do
      zfs destroy ${ZFSOPTS} ${d}
    done
  done
fi

