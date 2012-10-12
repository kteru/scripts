#!/bin/sh
#
# 20110531
# dump db, rotate dumpfiles
#
# GRANT ALL PRIVILEGES ON *.* TO backup@localhost IDENTIFIED BY 'hogehoge';
# ./mysqldump.sh -u backup -p hogehoge test
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# usage
#
_usage() {
  echo "usage:"
  echo "  ${0} -u dbuser -p dbpass [-d backupdir] [-g generation] dbname ..."
  echo "options:"
  echo "  -u dbuser       DB username"
  echo "  -p dbpass       DB password"
  echo "  -d backupdir    backup directory      default: /home/backup"
  echo "  -g generation   generations to keep   default: 7"
  exit 1
}


#
# getopts
#
while getopts :u:p:d:g: OPT; do
  case ${OPT} in
    u) ENABLE_u="t"; VALUE_u=${OPTARG};;
    p) ENABLE_p="t"; VALUE_p=${OPTARG};;
    d) ENABLE_d="t"; VALUE_d=${OPTARG};;
    g) ENABLE_g="t"; VALUE_g=${OPTARG};;

    :|\?) _usage;;
  esac
done

shift `expr ${OPTIND} - 1`


#
# check
#
[ "${ENABLE_u}" != "t" ] && _usage
[ "${ENABLE_p}" != "t" ] && _usage


#
# define
#
DB_USER=${VALUE_u}
DB_PASS=${VALUE_p}
DIR_BACKUP=${VALUE_d:-/home/backup}
GENERATION=${VALUE_g:-7}

DATABASES=$*


#
# main
#
test -d ${DIR_BACKUP} || mkdir -p ${DIR_BACKUP}

for db in ${DATABASES}; do
  # mysqldump
  _timestamp=`date +%Y%m%d_%H%M%S`
  mysqldump --default-character-set=binary --opt -c -u${DB_USER} -p${DB_PASS} ${db} > ${DIR_BACKUP}/mysqldump_${db}_${_timestamp}

  # delete old dumps
  _dumpfiles=`ls ${DIR_BACKUP}/mysqldump_${db}_*`
  _dellist=`echo "${_dumpfiles}" | sort -r | sed -e "1,${GENERATION}d"`

  for del in `echo "${_dellist}"`; do
    rm -f ${del}
  done
done

