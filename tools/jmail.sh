#!/bin/sh
#
# 20120706
# jmail.sh
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# usage
#
_usage() {
  echo "usage:"
  echo "  ${0} -t to@add.re.ss [-c cc@add.re.ss] [-f from@add.re.ss] [-s subject]"
  exit 1
}


#
# getopts
#
while getopts :t:s:f:c: OPT; do
  case ${OPT} in
    t) ENABLE_t="t"; VALUE_t="${OPTARG}";;
    s) ENABLE_s="t"; VALUE_s="${OPTARG}";;
    f) ENABLE_f="t"; VALUE_f="${OPTARG}";;
    c) ENABLE_c="t"; VALUE_c="${OPTARG}";;

    :|\?) _usage;;
  esac
done

shift `expr ${OPTIND} - 1`


#
# check
#
[ "${ENABLE_t}" != "t" ] && _usage


#
# process
#

# header
MAIL_HEADER=''

if [ "${ENABLE_f}" = "t" ]; then
  MAIL_HEADER=`cat <<EOL
${MAIL_HEADER}
From: ${VALUE_f}
EOL`
fi

if [ "${ENABLE_t}" = "t" ]; then
  MAIL_HEADER=`cat <<EOL
${MAIL_HEADER}
To: ${VALUE_t}
EOL`
fi

if [ "${ENABLE_c}" = "t" ]; then
  MAIL_HEADER=`cat <<EOL
${MAIL_HEADER}
Cc: ${VALUE_c}
EOL`
fi

if [ "${ENABLE_s}" = "t" ]; then
  encoded_subject=`echo "${VALUE_s}" | nkf -j | nkf -M`

  MAIL_HEADER=`cat <<EOL
${MAIL_HEADER}
Subject: ${encoded_subject}
EOL`
fi

MAIL_HEADER=`echo "${MAIL_HEADER}" | tail -n +2`

# body
MAIL_BODY=`cat /dev/stdin | nkf -j`

# 送信
cat <<EOL | sendmail -t
${MAIL_HEADER}
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

${MAIL_BODY}
EOL

