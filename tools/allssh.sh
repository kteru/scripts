#!/bin/sh
#
# 20120426
# all ssh
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH

COMMAND=${@:-true}

for host in `cat allssh.hosts | grep -v "^#"`; do
    echo "=== ${host} ==="
    ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oConnectTimeout=10 -q ${host} ${COMMAND}
done

