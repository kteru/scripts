#!/bin/sh
#
# ip6tables
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH

IP6TABLES=/sbin/ip6tables
IP6TABLES_INIT=/etc/init.d/ip6tables


_initialize() {
  ${IP6TABLES} -F
  ${IP6TABLES} -X
  ${IP6TABLES} -Z
  ${IP6TABLES} -P INPUT ACCEPT
  ${IP6TABLES} -P OUTPUT ACCEPT
  ${IP6TABLES} -P FORWARD ACCEPT
}

_finalize() {
  ${IP6TABLES_INIT} save && \
  ${IP6TABLES_INIT} restart
}

_initialize

#---------------

#---------------

trap '_finalize && exit 0' 2
echo "=> please press Ctrl-C within 30sec."
sleep 30
echo "=> 30sec has elapsed. rules are cleared."
_initialize

