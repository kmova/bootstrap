## Random Write Performance

The FIO tests were done on NVMe SSD in Google Cloud with write performance spec at 90K IOPS and 350MB/s BW. 
The FIO random write tests were executed with 16 jobs. 
Machine type is 4v CPU 16GB RAM

| OpenEBS Local PV Type                              |  IOPS        | BW       |  
| ---------------------------------------------------|-------------:|---------:|
| **fio ioengine=sync**                              |              |          |
| Device (NVMe device + XFS)                         |  98.6k       | 385MiB/s |
| Hostpath (NVMe device + XFS)                       |  97.1k       | 379MiB/s |
| Hostpath Rawfile (NVME device + ext4 sparse + XFS) | 112.0k       | 438MiB/s |
| ZPOOL ZFS (NVME device + ZFS)                      |  37.9k       | 148MiB/s |
| ZPOOL ZVOL (NVME device + ZVOL + XFS)              |  34.5k       | 135MiB/s |
| **fio ioengine=libaio**                            |              |          |
| Device (NVMe device + XFS)                         |  97.2k       | 380MiB/s |
| Hostpath (NVMe device + XFS)                       |  99.9k       | 390MiB/s |
| Hostpath Rawfile (NVME device + ext4 sparse + XFS) |  98.6k       | 385MiB/s |
| ZPOOL ZFS (NVME device + ZFS)                      |  37.3k       | 146MiB/s |
| ZPOOL ZVOL (NVME device + ZVOL + XFS)              |  36.6k       | 143MiB/s |


Note: running fio without containers for ZFS on the same machine gave the followign results. See [zfs_fio_test.sh](./zfs_fio_test.sh)
- fio-nvme: write: IOPS=144k, BW=562MiB/s (590MB/s)(165GiB/300041msec)
- fio-raw-zvol: write: IOPS=21.5k, BW=84.1MiB/s (88.1MB/s)(24.6GiB/300041msec)
- fio-mount-zvol: write: IOPS=15.5k, BW=60.4MiB/s (63.3MB/s)(18.1GiB/307340msec)

