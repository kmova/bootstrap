openebs-device-nvme-xfs

    local:
      fsType: xfs
      path: /dev/disk/by-id/google-local-nvme-ssd-2


Run status group 0 (all jobs):
  WRITE: bw=380MiB/s (398MB/s), 380MiB/s-380MiB/s (398MB/s-398MB/s), io=111GiB (120GB), run=300030-300030msec
Disk stats (read/write):
  nvme0n3: ios=0/29352385, merge=0/0, ticks=0/302995528, in_queue=256757332, util=97.40%

All tests complete.
=====================
= FIO bench Summary =
= ioengine=sync =
=====================
Random Write (4 jobs): IOPS: 39.4k / BW: 154MiB/s
Random Write (8 jobs): IOPS: 66.0k / BW: 262MiB/s
Random Write (16 jobs): IOPS: 98.6k / BW: 385MiB/s
=====================
= FIO bench Summary =
= ioengine=libaio =
=====================
Random Write (4 jobs): IOPS: 99.7k / BW: 389MiB/s
Random Write (8 jobs): IOPS: 97.1k / BW: 379MiB/s
Random Write (16 jobs): IOPS: 97.2k / BW: 380MiB/s



openebs-hostpath-nvme-xfs


/dev/nvme0n1 on /mnt/openebs_hostpath_xfs type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota)
/dev/nvme0n1 on /var/snap/microk8s/common/var/lib/kubelet/pods/b5b30cdd-aa2e-4aec-bc2f-04ab4c791b3c/volumes/kubernetes.io~local-

volume/pvc-b
a297775-06f7-4670-8b5c-c81e34df2e8e type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota)

   iops        : min=48678, max=161768, avg=100058.69, stdev=858.90, samples=9584
  cpu          : usr=1.38%, sys=4.02%, ctx=3371019, majf=0, minf=950
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,29978828,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64
Run status group 0 (all jobs):
  WRITE: bw=390MiB/s (409MB/s), 390MiB/s-390MiB/s (409MB/s-409MB/s), io=114GiB (123GB), run=300021-300021msec
Disk stats (read/write):
  nvme0n1: ios=0/30166241, merge=0/0, ticks=0/302374989, in_queue=255269944, util=100.00%
All tests complete.
=====================
= FIO bench Summary =
= ioengine=sync =
=====================
Random Write (4 jobs): IOPS: 42.2k / BW: 165MiB/s
Random Write (8 jobs): IOPS: 73.6k / BW: 288MiB/s
Random Write (16 jobs): IOPS: 97.1k / BW: 379MiB/s
=====================
= FIO bench Summary =
= ioengine=libaio =
=====================
Random Write (4 jobs): IOPS: 99.7k / BW: 389MiB/s
Random Write (8 jobs): IOPS: 99.6k / BW: 389MiB/s
Random Write (16 jobs): IOPS: 99.9k / BW: 390MiB/s


===============================


nvme device (ext4) + sparse file + xfs

sudo mkfs.ext4 /dev/nvme0n2
sudo mount /dev/nvme0n2 /mnt/openebs_hostpath_ext4
sudo trunc /mnt/openebs_hostpath_ext4/sparse/0-ndm-sparse.img (50g)  (created via NDM)
sudo mkfs.xfs /mnt/openebs_hostpath_ext4/sparse/0-ndm-sparse.img 
sudo mount /mnt/openebs_hostpath_ext4/sparse/0-ndm-sparse.img /mnt/sparse/disk-0

Testing Extended Write Bandwidth AIO 16 jobs...
ext_write_bw: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
...
fio-3.21-39-g87622
Starting 16 processes
ext_write_bw: (groupid=0, jobs=16): err= 0: pid=134: Sun Aug  2 15:01:35 2020
  write: IOPS=93.6k, BW=366MiB/s (383MB/s)(107GiB/300014msec); 0 zone resets
   bw (  KiB/s): min=85152, max=911258, per=100.00%, avg=403167.37, stdev=4359.04, samples=8897
   iops        : min=21288, max=227814, avg=100791.09, stdev=1089.75, samples=8897
  cpu          : usr=1.73%, sys=6.11%, ctx=7569019, majf=0, minf=934
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,28081979,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64
Run status group 0 (all jobs):
  WRITE: bw=366MiB/s (383MB/s), 366MiB/s-366MiB/s (383MB/s-383MB/s), io=107GiB (115GB), run=300014-300014msec
Disk stats (read/write):
  loop5: ios=0/28208027, merge=0/0, ticks=0/73480116, in_queue=24902656, util=91.47%
All tests complete.
=====================
= FIO bench Summary =
= ioengine=sync =
=====================
Random Write (4 jobs): IOPS: 58.5k / BW: 229MiB/s
Random Write (8 jobs): IOPS: 96.6k / BW: 377MiB/s
Random Write (16 jobs): IOPS: 112k / BW: 438MiB/s
=====================
= FIO bench Summary =
= ioengine=libaio =
=====================
Random Write (4 jobs): IOPS: 80.1k / BW: 313MiB/s
Random Write (8 jobs): IOPS: 90.3k / BW: 353MiB/s
Random Write (16 jobs): IOPS: 93.6k / BW: 366MiB/s


