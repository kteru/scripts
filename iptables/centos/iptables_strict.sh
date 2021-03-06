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

### policy ###
${IPTABLES} -P INPUT DROP
${IPTABLES} -P OUTPUT ACCEPT
${IPTABLES} -P FORWARD DROP
### policy ###

# ACCEPT lo
${IPTABLES} -A INPUT -i lo -j ACCEPT

# ACCEPT reply
${IPTABLES} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ACCEPT icmp
${IPTABLES} -A INPUT -p icmp -j ACCEPT

# REJECT tcp/113 ident
${IPTABLES} -A INPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset

#---------------

# ssh
${IPTABLES} -A INPUT -p tcp --dport 22 -j ACCEPT
# http, https
${IPTABLES} -A INPUT -p tcp --dport 80 -j ACCEPT
${IPTABLES} -A INPUT -p tcp --dport 443 -j ACCEPT

#---------------

### DROP ###
${IPTABLES} -A INPUT -j DROP
${IPTABLES} -A FORWARD -j DROP
### DROP ###

#---------------

trap '_finalize && exit 0' 2
echo "=> please press Ctrl-C within 30sec."
sleep 30
echo "=> 30sec has elapsed. rules are cleared."
_initialize

