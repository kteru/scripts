#!/bin/sh
#
# 20120905
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
  ${IPTABLES} -P INPUT DROP
  ${IPTABLES} -P OUTPUT ACCEPT
  ${IPTABLES} -P FORWARD DROP
}

_finalize() {
  ${IPTABLES_INIT} save && \
  ${IPTABLES_INIT} restart
}

_initialize

#---------------

# ACCEPT lo
${IPTABLES} -A INPUT -i lo -j ACCEPT

# ACCEPT reply
${IPTABLES} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# DROP ping of death
${IPTABLES} -N pod
${IPTABLES} -A pod -m limit --limit 1/s --limit-burst 5 -j ACCEPT
${IPTABLES} -A pod -j DROP
${IPTABLES} -A INPUT -p icmp --icmp-type echo-request -j pod

# REJECT tcp/113 ident
${IPTABLES} -A INPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset


# ssh
${IPTABLES} -A INPUT -p tcp --dport 22 -j ACCEPT
## dns
#${IPTABLES} -A INPUT -p udp --dport 53 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 53 -j ACCEPT
## http https
#${IPTABLES} -A INPUT -p tcp --dport 80 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 443 -j ACCEPT
## smtp submission smtps
#${IPTABLES} -A INPUT -p tcp --dport 25 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 587 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 465 -j ACCEPT
## pop3 pop3s imap imaps
#${IPTABLES} -A INPUT -p tcp --dport 110 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 995 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 143 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 993 -j ACCEPT
## mysql
#${IPTABLES} -A INPUT -p tcp --dport 3306 -j ACCEPT
## samba
#${IPTABLES} -A INPUT -p udp --dport 137 -j ACCEPT
#${IPTABLES} -A INPUT -p udp --dport 138 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 139 -j ACCEPT
#${IPTABLES} -A INPUT -p tcp --dport 445 -j ACCEPT
## ldap
#${IPTABLES} -A INPUT -p tcp --dport 389 -j ACCEPT
## mosh
#${IPTABLES} -A INPUT -p udp --dport 60000:61000 -j ACCEPT


# DROP ip
if [ -s "/root/deny_ip" ]; then
  for ip in `cat /root/deny_ip`; do
    ${IPTABLES} -I INPUT -s ${ip} -j DROP
  done
fi

# DROP
${IPTABLES} -A INPUT -j DROP
${IPTABLES} -A INPUT -j FORWARD

#---------------

trap '_finalize && exit 0' 2
echo "=> please press Ctrl-C within 30sec."
sleep 30
echo "=> 30sec has elapsed. rules are cleared."
_initialize

