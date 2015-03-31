#!/bin/sh
#
# iptables
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH

IPTABLES=/sbin/iptables
IPTABLES_INIT=/etc/init.d/iptables


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
  ${IPTABLES_INIT} save && \
  ${IPTABLES_INIT} restart
}

_initialize

#---------------

#---------------

trap '_finalize && exit 0' 2
echo "=> please press Ctrl-C within 30sec."
sleep 30
echo "=> 30sec has elapsed. rules are cleared."
_initialize

