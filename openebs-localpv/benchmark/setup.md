# Benchmarking the write performance for Kubernetes volumes. 

The following types of OpenEBS Dynamic Local Volumes were used for benchmarking.
- Local PV (device)
- Local PV (hostpath)
- Local PV (hostpath with loopback device)
- Local PV (ZPOOL + ZFS)
- Local PV (ZPOOL + ZVOL + XFS)


The tests were performed by launching a containerized `fio 3.21` pod and volumes passed via PVC/PV.
The following `fio` configuration was used:
  ```
  fio -group_reporting -numjobs=16 
  --randrepeat=0 
  --verify=0 
  --ioengine=sync 
  --bs=4K 
  --iodepth=64 
  --size=2G 
  --readwrite=randwrite 
  --time_based --ramp_time=2s --runtime=300s
  ```


The tests in this document are executed on a single node Kubernetes cluster.

Google Cloud instance configuration:
- Machine Type: n1-standard-4 (4 vCPUs, 15 GB memory)
- CPU Platform: Intel Haswell
- 4 Local SSDs connected via NVMe 375GB each. Write perf spec per SSD ( IOPS: 90K, BW: 350MB/s)
- Ubuntu 18.04

The 4 NVMe SSDs are visible via nvme as follows under `lsblk`:

  ```
  NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
  sda       8:0    0   100G  0 disk 
  ├─sda1    8:1    0  99.9G  0 part /
  ├─sda14   8:14   0     4M  0 part 
  └─sda15   8:15   0   106M  0 part /boot/efi
  nvme0n1 259:0    0   375G  0 disk 
  nvme0n2 259:1    0   375G  0 disk 
  nvme0n3 259:2    0   375G  0 disk 
  nvme0n4 259:3    0   375G  0 disk 
  ```

Setup Kubernetes via MicroK8s.  `kubectl get nodes` shows the following:

  ```
  NAME                  STATUS   ROLES    AGE    VERSION
  kmova-u18-n1s4-nvme   Ready    <none>   7h7m   v1.18.6-1+64f53401f200a7
  ```

The NVMe devices were configured as follows:

- nvme0n1 
  - format with xfs
  - mount at `/mnt/openebs_hostpath_xfs`
  - create openebs hostpath storage class(`openebs-hostpath-nvme-xfs`) with BasePath(`/mnt/openebs_hostpath_xfs/local`)
  - tag the block device as "in-use"

- nvme0n2
  - format with ext4
  - mount at `/mnt/openebs_hostpath_ext4`
  - create 50G sparse file via NDM by passing the above directory as sparse directory.
  - NDM will create a sparse file named: `/mnt/openebs_hostpath_ext4/sparse/0-ndm-sparse.img`
  - format the sparse file with xfs and mount it at `/mnt/sparse/disk-0`
  - create a static local pv and a corresponding static storage class for this sparse device. (Note: This is being automated via OpenEBS Local PV Rawfile CSI Driver)
  - tag the block device as "in-use"
  - tag the sparse block device as "sparse"


- nvme0n3
  - tag the block device as "nvme"
  - create openebs device storage class(`openebs-device-nvme-xfs`) with BlockDeviceTag(`nvme`)

- nvme0n4
  - tag the block device as "zfs"

