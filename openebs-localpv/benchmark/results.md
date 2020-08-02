## Random Write Performance

The FIO tests were done on NVMe SSD in Google Cloud with write performance spec at 90K IOPS and 350MB/s BW. The FIO random write tests were executed with 16 jobs. 

| OpenEBS Local PV Type                              |  IOPS        | BW       |  
| ---------------------------------------------------|-------------:|---------:|
| **fio ioengine=sync**                              |              |          |
| Device (NVMe device + XFS)                         |  98.6k       | 385MiB/s |
| Hostpath (NVMe device + XFS)                       |  97.1k       | 379MiB/s |
| Hostpath Rawfile (NVME device + ext4 sparse + XFS) | 112.0k       | 438MiB/s |
| ZPOOL ZFS (NVME device + ZFS)                      |              |          |
| ZPOOL ZVOL (NVME device + ZVOL + XFS)              |              |          |
| **fio ioengine=libaio**                            |              |          |
| Device (NVMe device + XFS)                         | 97.2k        | 380MiB/s |
| Hostpath (NVMe device + XFS)                       | 99.9k        | 390MiB/s |
| Hostpath Rawfile (NVME device + ext4 sparse + XFS) | 98.6k        | 385MiB/s |
| ZPOOL ZFS (NVME device + ZFS)                      |              |          |
| ZPOOL ZVOL (NVME device + ZVOL + XFS)              |              |          |


