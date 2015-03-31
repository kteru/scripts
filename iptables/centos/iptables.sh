#!/bin/sh
#
# iptables
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH

IPTABLES=/sbin/iptables

_initialize() {
  ${IPTABLES} -F
  ${IPTABLES} -F -t nat
  ${IPTABLES} -X
  ${IPTABLES} -Z
  ${IPTABLES} -P INPUT ACCEPT
  ${IPTABLES} -P OUTPUT ACCEPT
  ${IPTABLES} -P FORWARD ACCEPT
}

_finalize() {
  if [ -f /etc/rc.d/init.d/iptables ]; then
    /etc/rc.d/init.d/iptables save
  else
    /usr/libexec/iptables/iptables.init save
  fi
}

_initialize

#---------------

#---------------

trap '_finalize && exit 0' 2
echo "=> please press Ctrl-C within 30sec."
sleep 30
echo "=> 30sec has elapsed. rules are cleared."
_initialize

