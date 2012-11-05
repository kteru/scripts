#!/bin/sh
#
# 20121105
# unbound restart for FreeBSD
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


FILE_TMP=`mktemp /tmp/unbound-cache.XXXXXX`
if [ ! -w ${FILE_TMP} ]; then
  echo "tmpfile error."
  exit 1
fi

unbound-control dump_cache > ${FILE_TMP}
/usr/local/etc/rc.d/unbound onerestart
unbound-control load_cache < ${FILE_TMP}

rm -f ${FILE_TMP}

