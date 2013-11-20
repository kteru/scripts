#!/bin/sh
#
# 20110323
# adding service for daemontools
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


#
# define
#
SERVICE_NAME=${1}
SERVICE_DIR=${2:-/var/service}


#
# usage, error
#
[ $# = 0 ] && {
  echo "usage:"
  echo "${0} name [dir]"
  exit 1
}

[ -d ${SERVICE_DIR}/${SERVICE_NAME} ] && {
  echo "error:"
  echo "${SERVICE_NAME} is exist."
  exit 1
}


#
# directory, file
#
if [ ! -d ${SERVICE_DIR} ]; then
  mkdir ${SERVICE_DIR}
fi

mkdir ${SERVICE_DIR}/${SERVICE_NAME}
chmod +t ${SERVICE_DIR}/${SERVICE_NAME}
mkdir ${SERVICE_DIR}/${SERVICE_NAME}/log
mkdir ${SERVICE_DIR}/${SERVICE_NAME}/log/main
touch ${SERVICE_DIR}/${SERVICE_NAME}/log/status


#
# run script (for service)
#
cat <<EOF > ${SERVICE_DIR}/${SERVICE_NAME}/run
#!/bin/sh

PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH

sleep 3
exec 2>&1

EOF
chmod 755 ${SERVICE_DIR}/${SERVICE_NAME}/run


#
# run script (for log)
#
cat <<EOF > ${SERVICE_DIR}/${SERVICE_NAME}/log/run
#!/bin/sh

exec multilog t s1000000 n100 ./main
EOF
chmod 755 ${SERVICE_DIR}/${SERVICE_NAME}/log/run

