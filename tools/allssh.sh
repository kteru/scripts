#!/bin/sh
#
# 20130718
# all ssh
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH
DIR_BASE=$(cd $(dirname ${0}); pwd)


# usage
_usage() {
  echo "usage:"
  echo "  ${0} -l hostlist [-u user]"
  exit 1
}

# getopts
while getopts :l:u: OPT; do
  case ${OPT} in
    l) ENABLE_l="t"; VALUE_l=${OPTARG};;
    u) ENABLE_u="t"; VALUE_u=${OPTARG};;

    :|\?) _usage;;
  esac
done

shift $((OPTIND - 1))

# check
[ "${ENABLE_l}" != "t" ] && _usage

# make opts
HOST_LIST="${VALUE_l}"
SSH_USER="${VALUE_u:-root}"


#
# GO
#

trap 'kill $$' 2

command=`cat /dev/stdin`

for host in `cat "${VALUE_l}" | grep -v "^#"`; do
    echo "=== ${host} ==="
    echo "${command}" | ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oConnectTimeout=10 -q ${SSH_USER}@${host} bash
done

