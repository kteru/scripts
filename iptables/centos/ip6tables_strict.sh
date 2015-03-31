#!/bin/sh
#
# ip6tables
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH

IP6TABLES=/sbin/ip6tables

_initialize() {
  ${IP6TABLES} -F
  ${IP6TABLES} -X
  ${IP6TABLES} -Z
  ${IP6TABLES} -P INPUT ACCEPT
  ${IP6TABLES} -P OUTPUT ACCEPT
  ${IP6TABLES} -P FORWARD ACCEPT
}

_finalize() {
  if [ -f /etc/rc.d/init.d/ip6tables ]; then
    /etc/rc.d/init.d/ip6tables save
  else
    /usr/libexec/iptables/ip6tables.init save
  fi
}

_initialize

#---------------

### policy ###
${IP6TABLES} -P INPUT DROP
${IP6TABLES} -P OUTPUT ACCEPT
${IP6TABLES} -P FORWARD DROP
### policy ###

# ACCEPT lo
${IP6TABLES} -A INPUT -i lo -j ACCEPT

# ACCEPT reply
${IP6TABLES} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ACCEPT icmpv6
${IP6TABLES} -A INPUT -p icmpv6 -j ACCEPT

# REJECT tcp/113 ident
${IP6TABLES} -A INPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset

#---------------

# ssh
${IP6TABLES} -A INPUT -p tcp --dport 22 -j ACCEPT
# http, https
${IP6TABLES} -A INPUT -p tcp --dport 80 -j ACCEPT
${IP6TABLES} -A INPUT -p tcp --dport 443 -j ACCEPT

#---------------

### DROP ###
${IP6TABLES} -A INPUT -j DROP
${IP6TABLES} -A FORWARD -j DROP
### DROP ###

#---------------

trap '_finalize && exit 0' 2
echo "=> please press Ctrl-C within 30sec."
sleep 30
echo "=> 30sec has elapsed. rules are cleared."
_initialize

