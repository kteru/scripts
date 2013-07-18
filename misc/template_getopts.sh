#!/bin/bash
#
# 20111207
# getopts template
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH
DIR_BASE=$(cd $(dirname ${0}); pwd)


#
# usage
#
_usage() {
  echo "usage:"
  echo "  ${0} -a -b HOGE [-c] [-d FOO] [BAR]"
  echo ""
  echo "options:"
  echo "  -d  param d  default: PIYO"
  echo ""
  exit 1
}


#
# getopts
#
while getopts :ab:cd: OPT; do
  case ${OPT} in
    a) ENABLE_a="t";;
    b) ENABLE_b="t"; VALUE_b=${OPTARG};;
    c) ENABLE_c="t";;
    d) ENABLE_d="t"; VALUE_d=${OPTARG};;

    :|\?) _usage;;
  esac
done

shift $((OPTIND - 1))


#
# check
#
[ "${ENABLE_a}" != "t" ] && _usage
[ "${ENABLE_b}" != "t" ] && _usage


#
# make vars
#
PARAM_b="${VALUE_b}"
PARAM_d="${VALUE_d:-PIYO}"


#
# GO
#
echo "\${0}: ${0}"
echo "\${1}: ${1}"
[ "${ENABLE_a}" = "t" ] && echo "-a"
[ "${ENABLE_b}" = "t" ] && echo "-b: ${VALUE_b}"
[ "${ENABLE_c}" = "t" ] && echo "-c"
[ "${ENABLE_d}" = "t" ] && echo "-d: ${VALUE_d}"
echo "\${PARAM_b}: ${PARAM_b}"
echo "\${PARAM_d}: ${PARAM_d}"

