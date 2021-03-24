Reference: 
- https://fabianlee.org/2020/01/13/linux-using-xfs-project-quotas-to-limit-capacity-within-a-subdirectory/

```
sudo mkfs.xfs /dev/sdb
sudo mkdir -p /mnt/xfs_hostpath
sudo mount -o pquota /dev/sdb /mnt/xfs_hostpath


sudo mkdir -p /mnt/xfs_hostpath/vol5m
sudo xfs_quota -x -c 'project -s -p /mnt/xfs_hostpath/vol5m 100' /mnt/xfs_hostpath
sudo xfs_quota -x -c 'limit -p bsoft=5m bhard=5m 100' /mnt/xfs_hostpath

sudo mkdir -p /mnt/xfs_hostpath/vol10m
sudo xfs_quota -x -c 'project -s -p /mnt/xfs_hostpath/vol10m 200' /mnt/xfs_hostpath
sudo xfs_quota -x -c 'limit -p bsoft=10m bhard=10m 200' /mnt/xfs_hostpath


sudo mkdir -p /mnt/xfs_hostpath/vol15m
ls -id /mnt/xfs_hostpath/vol15m
sudo xfs_quota -x -c 'project -s -p /mnt/xfs_hostpath/vol15m 134320224' /mnt/xfs_hostpath
sudo xfs_quota -x -c 'limit -p bsoft=15m bhard=15m 134320224' /mnt/xfs_hostpath
```

