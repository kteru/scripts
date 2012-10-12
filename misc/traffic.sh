#!/bin/sh
#
# 20120202
# traffic monitor
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH


NIC=${1:-eth0}

echo "${NIC} traffic (kbps)"
echo "epoch            recv       sent"
echo "--------------------------------"

while : ; do
    _data=`cat /proc/net/dev | grep "${NIC}" | sed -e 's/.*://'`
    _t1_recv=`echo ${_data} | awk '{print $1}'`
    _t1_sent=`echo ${_data} | awk '{print $9}'`
    sleep 1;
    _data=`cat /proc/net/dev | grep "${NIC}" | sed -e 's/.*://'`
    _t2_recv=`echo ${_data} | awk '{print $1}'`
    _t2_sent=`echo ${_data} | awk '{print $9}'`

    _bps_recv=`echo "( ${_t2_recv} - ${_t1_recv} ) * 8" | bc`;
    _bps_sent=`echo "( ${_t2_sent} - ${_t1_sent} ) * 8" | bc`;
    _kbps_recv=`echo "scale=2; ${_bps_recv} / 1000" | bc`
    _kbps_sent=`echo "scale=2; ${_bps_sent} / 1000" | bc`

    echo -n "`date +%s` "
    printf "%10.2f %10.2f\n" ${_kbps_recv} ${_kbps_sent}
done

