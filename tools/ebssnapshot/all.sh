#!/usr/bin/env bash
#
# 2014/08/24 teru <teru@kteru.net>
#
PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin
export PATH
DIR_BASE=$(cd ${BASH_SOURCE[0]%/*} && pwd)


#
# vars
#
export AWS_CONFIG_FILE="${DIR_BASE}/awscli.conf"
export TZ=JST-9
GENERATION=3


#
# GO
#
VOLUME_IDS=`aws --output text ec2 describe-instances --filters 'Name=tag:Name,Values=*' --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].Ebs.VolumeId'`

### take snapshots
for volume_id in ${VOLUME_IDS}; do
  _timestamp=`date --rfc-3339 seconds`
  aws ec2 create-snapshot --volume-id ${volume_id} --description "${volume_id} (${_timestamp})" > /dev/null
done

SNAPSHOTS=`aws --output text ec2 describe-snapshots --owner-ids self --query "Snapshots[*].[VolumeId,StartTime,SnapshotId]"`

### delete old snapshots
for volume_id in ${VOLUME_IDS}; do
  _snapshot_ids=`echo "${SNAPSHOTS}" | grep "${volume_id}" | sort -k 2 -r | sed -e "1,${GENERATION}d" | cut -f 3`
  for snapshot_id in ${_snapshot_ids}; do
    aws ec2 delete-snapshot --snapshot-id ${snapshot_id} > /dev/null
  done
done

