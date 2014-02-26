#!/usr/bin/env bash
#
# 20140225
# template
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH
DIR_BASE=$(cd ${BASH_SOURCE[0]%/*} && pwd)


#
# usage
#
_usage() {
  echo "usage:"
  echo "  ${0} [-a] -b hoge [--long-a] [--long-b=huga] var"
  echo ""
  echo "options:"
  echo "  -a"
  echo "  -b hoge         (required)"
  echo "  --long-a"
  echo "  --long-b=huga"
  echo "  var             (required)"
  echo ""
  exit 1
}


#
# parsing options
#
for var in "${@}"; do
  case "${var}" in
    --long-a)
      ENABLE_long_a="t"
      ;;
    --long-b=*)
      ENABLE_long_b="t"
      VALUE_long_b=${var#--long-b=}
      ;;

    --*) _usage;;
    *) newopts="${newopts} ${var}";;
  esac
done

set -- ${newopts}
unset var newopts

while getopts :ab: OPT; do
  case "${OPT}" in
    a) ENABLE_a="t";;
    b) ENABLE_b="t"; VALUE_b=${OPTARG};;

    :|\?) _usage;;
  esac
done

shift $((OPTIND - 1))


#
# check
#
[ "${ENABLE_b}" != "t" ] && _usage
[ "${1}" = "" ] && _usage


#
# GO
#
echo "\${ENABLE_a}      : ${ENABLE_a}"
echo "\${ENABLE_b}      : ${ENABLE_b}"
echo "\${VALUE_b}       : ${VALUE_b}"
echo "\${ENABLE_long_a} : ${ENABLE_long_a}"
echo "\${ENABLE_long_b} : ${ENABLE_long_b}"
echo "\${VALUE_long_b}  : ${VALUE_long_b}"
echo "\${1}             : ${1}"

