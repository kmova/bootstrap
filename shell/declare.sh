#!/bin/bash
set -e

get_nfs_args() {
  declare -a args=$1

  args=(--debug 8 --no-udp --no-nfs-version 2 --no-nfs-version 3)
  if [ ! -z ${NFS_GRACE_TIME} ]; then
    args+=( --grace-time ${NFS_GRACE_TIME})
  fi

  if [ ! -z ${NFS_LEASE_TIME} ]; then
    args+=( --lease-time ${NFS_LEASE_TIME})
  fi
}


get_nfs_args nfs_args
echo ${nfs_args[@]}
