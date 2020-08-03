## Random Write Performance

- The FIO tests were done on NVMe SSD in Google Cloud with write performance spec at 90K IOPS and 350MB/s BW. 
- The FIO random write tests were executed with 16 jobs. 
- See [setup.md](./setup.md).

### Machine - 4v CPU 16GB RAM

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


### Machine - 16v CPU 60GB RAM

| OpenEBS Local PV Type                              |  IOPS        | BW       |  
| ---------------------------------------------------|-------------:|---------:|
| **fio ioengine=sync**                              |              |          |
| Device (NVMe device + XFS)                         |  99.0k       | 391MiB/s |
| Hostpath (NVMe device + XFS)                       | 100.0k       | 391MiB/s |
| Hostpath Rawfile (NVME device + ext4 sparse + XFS) | 150.0k       | 585MiB/s |
| ZPOOL ZFS (NVME device + ZFS)                      |  50.9k       | 199MiB/s |
| ZPOOL ZVOL (NVME device + ZVOL + XFS)              |  84.2k       | 329MiB/s |
| **fio ioengine=libaio**                            |              |          |
| Device (NVMe device + XFS)                         |  99.0k       | 391MiB/s |
| Hostpath (NVMe device + XFS)                       |  99.0k       | 391MiB/s |
| Hostpath Rawfile (NVME device + ext4 sparse + XFS) | 156.6k       | 608MiB/s |
| ZPOOL ZFS (NVME device + ZFS)                      |  56.0k       | 219MiB/s |
| ZPOOL ZVOL (NVME device + ZVOL + XFS)              |  97.1k       | 379MiB/s |

### Additional Notes

Running `fio` without containers for ZFS on the same machine gave the following results. See [zfs_fio_test.sh](./zfs_fio_test.sh)

#### Machine 4v CPU, 16GB RAM

- fio-nvme: IOPS=146k, BW=571MiB/s (599MB/s)(167GiB/300036msec)
- fio-ds: IOPS=29.5k, BW=115MiB/s (121MB/s)(33.7GiB/300033msec)
- fio-raw-zvol: IOPS=39.5k, BW=154MiB/s (162MB/s)(45.2GiB/300061msec)
- fio-mount-zvol: IOPS=22.6k, BW=88.4MiB/s (92.7MB/s)(26.6GiB/308400msec)


#### Machine 16v CPU, 30GB RAM

- fio-nvme: IOPS=2627k, BW=10.0GiB/s (10.8GB/s)(3007GiB/300001msec)
- fio-nvme-xfs: IOPS=388k, BW=1514MiB/s (1588MB/s)(444GiB/300001msec)
- fio-ds: IOPS=74.9k, BW=293MiB/s (307MB/s)(85.7GiB/300001msec)
- fio-raw-zvol: IOPS=97.9k, BW=382MiB/s (401MB/s)(112GiB/300041msec)
- fio-mount-zvol: IOPS=73.9k, BW=289MiB/s (303MB/s)(84.6GiB/300069msec)

#### Running dd test on 6v CPU, 30GB RAM

ZFS Dataset with 4K recordsize
```
# date; time (dd if=/dev/zero of=/zfspv-pool/ds-4k/zeros.dat bs=4k count=10000000 && sync) ; date
Mon Aug  3 16:40:37 UTC 2020
10000000+0 records in
10000000+0 records out
40960000000 bytes (41 GB, 38 GiB) copied, 152.043 s, 269 MB/s
real    2m33.683s
user    0m7.113s
sys     2m23.823s
Mon Aug  3 16:43:11 UTC 2020
```

ZFS Dataset with 128K recordsize
```
# date; time (dd if=/dev/zero of=/zfspv-pool/ds/zeros.dat bs=4k count=10000000 && sync) ; date
Mon Aug  3 16:47:49 UTC 2020
10000000+0 records in
10000000+0 records out
40960000000 bytes (41 GB, 38 GiB) copied, 97.0494 s, 422 MB/s
real    1m43.580s
user    0m5.996s
sys     1m26.870s
Mon Aug  3 16:49:33 UTC 2020
```

ZVOL + XFS with 4K Block Size
```
# date; time (dd if=/dev/zero of=./zvol/zeros.dat bs=4k count=10000000 && sync) ; date
Mon Aug  3 16:55:36 UTC 2020
10000000+0 records in
10000000+0 records out
40960000000 bytes (41 GB, 38 GiB) copied, 117.383 s, 349 MB/s
real    2m34.874s
user    0m6.478s
sys     0m36.412s
Mon Aug  3 16:58:11 UTC 2020
```


ZVOL + XFS with 128K Block Size
```
# date; time (dd if=/dev/zero of=./zvol/zeros.dat bs=4k count=10000000 && sync) ; date
Mon Aug  3 17:03:14 UTC 2020
10000000+0 records in
10000000+0 records out
40960000000 bytes (41 GB, 38 GiB) copied, 77.893 s, 526 MB/s
real    1m48.331s
user    0m5.608s
sys     0m27.155s
Mon Aug  3 17:05:03 UTC 2020
```


