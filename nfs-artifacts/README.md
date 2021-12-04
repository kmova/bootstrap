# FIO Scripts Used To Benchmark NFS Volume

- Performance test results were collected by deploying fbench.yaml by updating StorageClassName.
- fbench.yaml will run particular each test for 3 times and display test results + test summary at end.
  Test summary is calculated by taking average on particular test[r1+r2+r3)/3].
- Inputs like iodepth, filesize, mount point, and runtime can be controlled by updating environment variables under fbench.yaml

**Note**: Please update with appropriate  `StorageClassName` in [fbench.yaml](../fio/fbench.yaml) before deploying it.

### Sample Example
- YAML that was used to get output performace results

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: openebs-rwx-volume
spec:
  storageClassName: openebs-rwx
  # storageClassName: ganesha-nfs
  # storageClassName: gp2
  # storageClassName: local-storage
  # storageClassName: ibmc-block-bronze
  # storageClassName: ibmc-block-silver
  # storageClassName: ibmc-block-gold
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Gi
---
apiVersion: batch/v1
kind: Job
metadata:
  name: fbench
spec:
  template:
    spec:
      containers:
      - name: fbench
        image: mittachaitu/alpine-fio:latest
        imagePullPolicy: IfNotPresent
        command:
          - sh
          - -c
          - '/docker-entrypoint.sh fio'
        env:
          - name: FBENCH_MOUNTPOINT
            value: /data
          - name: FBENCH_QUICK
            value: "no"
          - name: FIO_SIZE
            value: 50G
          - name: FIO_DIRECT
            value: "1"
          - name: RUNTIME
            value: "60"
          - name: IODEPTH
            value: "128"
        volumeMounts:
        - name: fbench-pv
          mountPath: /data
      restartPolicy: Never
      volumes:
      - name: fbench-pv
        persistentVolumeClaim:
          claimName: openebs-rwx-volume
  backoffLimit: 4
```

#### Sample Output

- Below results are collected by deploying fbench.yaml with openebs-rwx StorageClass(Backend StorageClass is `do-block-storage` default StorageClass from DigitalOcean).
```sh
Working dir: /data
Fio version: fio-3.27-16-gdd46

========================= Testing Random Read...  ===========================
Test run 0
read_iops: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process
read_iops: Laying out IO file (1 file / 51200MiB)

read_iops: (groupid=0, jobs=1): err= 0: pid=11: Tue Jun 15 04:10:36 2021
  read: IOPS=3588, BW=14.0MiB/s (14.7MB/s)(843MiB/60093msec)
    slat (nsec): min=1842, max=868855, avg=11176.18, stdev=10338.06
    clat (msec): min=4, max=979, avg=17.84, stdev=14.78
     lat (msec): min=4, max=979, avg=17.85, stdev=14.78
    clat percentiles (msec):
     |  1.00th=[    8],  5.00th=[    9], 10.00th=[   10], 20.00th=[   11],
     | 30.00th=[   13], 40.00th=[   14], 50.00th=[   15], 60.00th=[   17],
     | 70.00th=[   19], 80.00th=[   22], 90.00th=[   27], 95.00th=[   35],
     | 99.00th=[   70], 99.50th=[  103], 99.90th=[  188], 99.95th=[  218],
     | 99.99th=[  368]
   bw (  KiB/s): min= 1442, max=23184, per=100.00%, avg=14379.73, stdev=3511.04, samples=120
   iops        : min=  360, max= 5796, avg=3594.89, stdev=877.78, samples=120
  lat (msec)   : 10=12.06%, 20=64.33%, 50=21.77%, 100=1.35%, 250=0.49%
  lat (msec)   : 500=0.03%, 750=0.01%, 1000=0.01%
  cpu          : usr=2.07%, sys=4.97%, ctx=188889, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=215650,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=14.0MiB/s (14.7MB/s), 14.0MiB/s-14.0MiB/s (14.7MB/s-14.7MB/s), io=843MiB (884MB), run=60093-60093msec
Test run 1
read_iops: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process

read_iops: (groupid=0, jobs=1): err= 0: pid=65: Tue Jun 15 04:11:38 2021
  read: IOPS=3888, BW=15.2MiB/s (15.9MB/s)(912MiB/60032msec)
    slat (usec): min=2, max=1456, avg=10.93, stdev=10.48
    clat (msec): min=5, max=1031, avg=16.44, stdev=13.84
     lat (msec): min=5, max=1031, avg=16.45, stdev=13.84
    clat percentiles (msec):
     |  1.00th=[    8],  5.00th=[    9], 10.00th=[   10], 20.00th=[   11],
     | 30.00th=[   12], 40.00th=[   13], 50.00th=[   14], 60.00th=[   16],
     | 70.00th=[   17], 80.00th=[   20], 90.00th=[   25], 95.00th=[   31],
     | 99.00th=[   62], 99.50th=[   90], 99.90th=[  155], 99.95th=[  236],
     | 99.99th=[  380]
   bw (  KiB/s): min= 6384, max=22957, per=100.00%, avg=15567.25, stdev=3245.32, samples=120
   iops        : min= 1596, max= 5739, avg=3891.77, stdev=811.33, samples=120
  lat (msec)   : 10=15.66%, 20=66.45%, 50=16.38%, 100=1.13%, 250=0.35%
  lat (msec)   : 500=0.04%, 750=0.01%, 1000=0.01%, 2000=0.01%
  cpu          : usr=2.22%, sys=5.20%, ctx=202372, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=233456,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=15.2MiB/s (15.9MB/s), 15.2MiB/s-15.2MiB/s (15.9MB/s-15.9MB/s), io=912MiB (956MB), run=60032-60032msec
Test run 2
read_iops: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process

read_iops: (groupid=0, jobs=1): err= 0: pid=119: Tue Jun 15 04:12:41 2021
  read: IOPS=3748, BW=14.6MiB/s (15.4MB/s)(879MiB/60029msec)
    slat (nsec): min=1880, max=1418.2k, avg=10793.46, stdev=9929.97
    clat (msec): min=5, max=1615, avg=17.06, stdev=13.40
     lat (msec): min=5, max=1615, avg=17.07, stdev=13.40
    clat percentiles (msec):
     |  1.00th=[    8],  5.00th=[    9], 10.00th=[   10], 20.00th=[   11],
     | 30.00th=[   12], 40.00th=[   14], 50.00th=[   15], 60.00th=[   16],
     | 70.00th=[   18], 80.00th=[   21], 90.00th=[   26], 95.00th=[   33],
     | 99.00th=[   65], 99.50th=[   88], 99.90th=[  144], 99.95th=[  180],
     | 99.99th=[  330]
   bw (  KiB/s): min= 6064, max=22832, per=100.00%, avg=15004.39, stdev=3058.43, samples=120
   iops        : min= 1516, max= 5708, avg=3751.05, stdev=764.60, samples=120
  lat (msec)   : 10=12.09%, 20=67.14%, 50=19.12%, 100=1.34%, 250=0.32%
  lat (msec)   : 500=0.01%, 750=0.01%, 1000=0.01%, 2000=0.01%
  cpu          : usr=2.09%, sys=5.14%, ctx=192797, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=225011,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=14.6MiB/s (15.4MB/s), 14.6MiB/s-14.6MiB/s (15.4MB/s-15.4MB/s), io=879MiB (922MB), run=60029-60029msec


========================= Testing Random Read Completed...  ===========================
========================= Testing Random Write... ===================================
Test run 0
write_iops: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process

write_iops: (groupid=0, jobs=1): err= 0: pid=173: Tue Jun 15 04:13:43 2021
  write: IOPS=11.4k, BW=44.6MiB/s (46.8MB/s)(2678MiB/60025msec); 0 zone resets
    slat (nsec): min=1846, max=7667.4k, avg=8798.06, stdev=25761.63
    clat (usec): min=269, max=145949, avg=5592.30, stdev=10608.81
     lat (usec): min=289, max=145955, avg=5601.30, stdev=10608.86
    clat percentiles (usec):
     |  1.00th=[  1450],  5.00th=[  1860], 10.00th=[  2024], 20.00th=[  2212],
     | 30.00th=[  2343], 40.00th=[  2474], 50.00th=[  2606], 60.00th=[  2737],
     | 70.00th=[  2933], 80.00th=[  3261], 90.00th=[  6325], 95.00th=[ 27919],
     | 99.00th=[ 54789], 99.50th=[ 62653], 99.90th=[107480], 99.95th=[129500],
     | 99.99th=[141558]
   bw (  KiB/s): min=15088, max=108384, per=100.00%, avg=45716.87, stdev=30664.30, samples=120
   iops        : min= 3772, max=27096, avg=11429.14, stdev=7666.08, samples=120
  lat (usec)   : 500=0.01%, 750=0.04%, 1000=0.13%
  lat (msec)   : 2=8.93%, 4=78.26%, 10=3.43%, 20=0.52%, 50=7.41%
  lat (msec)   : 100=1.17%, 250=0.13%
  cpu          : usr=3.48%, sys=8.95%, ctx=465094, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,685559,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
  WRITE: bw=44.6MiB/s (46.8MB/s), 44.6MiB/s-44.6MiB/s (46.8MB/s-46.8MB/s), io=2678MiB (2808MB), run=60025-60025msec
Test run 1
write_iops: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process
write_iops: Laying out IO file (1 file / 51200MiB)

write_iops: (groupid=0, jobs=1): err= 0: pid=229: Tue Jun 15 04:14:48 2021
  write: IOPS=9295, BW=36.3MiB/s (38.1MB/s)(2180MiB/60023msec); 0 zone resets
    slat (nsec): min=1834, max=2886.2k, avg=8075.46, stdev=20736.94
    clat (usec): min=265, max=119326, avg=6874.42, stdev=12116.50
     lat (usec): min=364, max=119329, avg=6882.67, stdev=12116.92
    clat percentiles (usec):
     |  1.00th=[  1401],  5.00th=[  1811], 10.00th=[  1991], 20.00th=[  2180],
     | 30.00th=[  2311], 40.00th=[  2442], 50.00th=[  2573], 60.00th=[  2737],
     | 70.00th=[  2933], 80.00th=[  3326], 90.00th=[ 25297], 95.00th=[ 40109],
     | 99.00th=[ 52691], 99.50th=[ 55313], 99.90th=[ 69731], 99.95th=[ 92799],
     | 99.99th=[106431]
   bw (  KiB/s): min= 7384, max=119752, per=100.00%, avg=37208.04, stdev=30753.83, samples=120
   iops        : min= 1846, max=29938, avg=9301.96, stdev=7688.46, samples=120
  lat (usec)   : 500=0.01%, 750=0.04%, 1000=0.10%
  lat (msec)   : 2=10.30%, 4=74.75%, 10=2.16%, 20=0.47%, 50=10.44%
  lat (msec)   : 100=1.70%, 250=0.04%
  cpu          : usr=2.83%, sys=7.01%, ctx=351602, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,557946,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
  WRITE: bw=36.3MiB/s (38.1MB/s), 36.3MiB/s-36.3MiB/s (38.1MB/s-38.1MB/s), io=2180MiB (2286MB), run=60023-60023msec
Test run 2
write_iops: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process
write_iops: Laying out IO file (1 file / 51200MiB)

write_iops: (groupid=0, jobs=1): err= 0: pid=282: Tue Jun 15 04:15:53 2021
  write: IOPS=8987, BW=35.1MiB/s (36.8MB/s)(2108MiB/60023msec); 0 zone resets
    slat (nsec): min=1788, max=7256.5k, avg=8828.23, stdev=24108.13
    clat (usec): min=262, max=171382, avg=7109.10, stdev=12973.91
     lat (usec): min=265, max=171387, avg=7118.13, stdev=12974.04
    clat percentiles (usec):
     |  1.00th=[  1303],  5.00th=[  1745], 10.00th=[  1926], 20.00th=[  2114],
     | 30.00th=[  2278], 40.00th=[  2376], 50.00th=[  2540], 60.00th=[  2671],
     | 70.00th=[  2900], 80.00th=[  3261], 90.00th=[ 30540], 95.00th=[ 43779],
     | 99.00th=[ 50594], 99.50th=[ 53740], 99.90th=[ 66847], 99.95th=[ 94897],
     | 99.99th=[166724]
   bw (  KiB/s): min=11856, max=117507, per=100.00%, avg=35975.64, stdev=31099.51, samples=120
   iops        : min= 2964, max=29376, avg=8993.85, stdev=7774.86, samples=120
  lat (usec)   : 500=0.02%, 750=0.04%, 1000=0.14%
  lat (msec)   : 2=13.23%, 4=72.56%, 10=2.03%, 20=0.15%, 50=10.45%
  lat (msec)   : 100=1.36%, 250=0.03%
  cpu          : usr=2.88%, sys=6.48%, ctx=360956, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,539485,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
  WRITE: bw=35.1MiB/s (36.8MB/s), 35.1MiB/s-35.1MiB/s (36.8MB/s-36.8MB/s), io=2108MiB (2210MB), run=60023-60023msec


========================= Testing Random Write Completed...  ===========================
======================================= Testing Read Sequential... ============================
Test run 0
read_seq: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process
read_seq: Laying out IO file (1 file / 51200MiB)

read_seq: (groupid=0, jobs=1): err= 0: pid=335: Tue Jun 15 04:21:32 2021
  read: IOPS=19.3k, BW=75.6MiB/s (79.2MB/s)(4534MiB/60003msec)
    slat (nsec): min=1645, max=5436.6k, avg=9402.58, stdev=25878.19
    clat (usec): min=271, max=206856, avg=3297.98, stdev=5074.04
     lat (usec): min=275, max=206866, avg=3307.61, stdev=5074.01
    clat percentiles (usec):
     |  1.00th=[  1401],  5.00th=[  1795], 10.00th=[  1975], 20.00th=[  2180],
     | 30.00th=[  2343], 40.00th=[  2507], 50.00th=[  2638], 60.00th=[  2802],
     | 70.00th=[  2999], 80.00th=[  3294], 90.00th=[  4015], 95.00th=[  5342],
     | 99.00th=[ 13566], 99.50th=[ 26870], 99.90th=[ 79168], 99.95th=[105382],
     | 99.99th=[164627]
   bw (  KiB/s): min= 5120, max=101448, per=100.00%, avg=77393.07, stdev=19554.01, samples=120
   iops        : min= 1280, max=25362, avg=19348.22, stdev=4888.51, samples=120
  lat (usec)   : 500=0.01%, 750=0.05%, 1000=0.14%
  lat (msec)   : 2=10.84%, 4=78.76%, 10=8.21%, 20=1.31%, 50=0.42%
  lat (msec)   : 100=0.20%, 250=0.06%
  cpu          : usr=4.35%, sys=14.91%, ctx=814162, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=1160603,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=75.6MiB/s (79.2MB/s), 75.6MiB/s-75.6MiB/s (79.2MB/s-79.2MB/s), io=4534MiB (4754MB), run=60003-60003msec
Test run 1
read_seq: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process

read_seq: (groupid=0, jobs=1): err= 0: pid=389: Tue Jun 15 04:22:35 2021
  read: IOPS=25.8k, BW=101MiB/s (106MB/s)(6051MiB/60003msec)
    slat (nsec): min=1593, max=5677.0k, avg=9231.50, stdev=25071.51
    clat (usec): min=187, max=247340, avg=2468.42, stdev=2672.45
     lat (usec): min=264, max=247348, avg=2477.87, stdev=2672.42
    clat percentiles (usec):
     |  1.00th=[  1106],  5.00th=[  1549], 10.00th=[  1696], 20.00th=[  1876],
     | 30.00th=[  2008], 40.00th=[  2114], 50.00th=[  2212], 60.00th=[  2343],
     | 70.00th=[  2507], 80.00th=[  2704], 90.00th=[  3097], 95.00th=[  3654],
     | 99.00th=[  6915], 99.50th=[ 10028], 99.90th=[ 29492], 99.95th=[ 47973],
     | 99.99th=[125305]
   bw (  KiB/s): min=32312, max=135142, per=100.00%, avg=103294.82, stdev=19544.18, samples=120
   iops        : min= 8078, max=33785, avg=25823.66, stdev=4886.06, samples=120
  lat (usec)   : 250=0.01%, 500=0.04%, 750=0.18%, 1000=0.41%
  lat (msec)   : 2=29.42%, 4=66.37%, 10=3.08%, 20=0.34%, 50=0.11%
  lat (msec)   : 100=0.03%, 250=0.02%
  cpu          : usr=5.34%, sys=18.68%, ctx=1127814, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=1549000,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=101MiB/s (106MB/s), 101MiB/s-101MiB/s (106MB/s-106MB/s), io=6051MiB (6345MB), run=60003-60003msec
Test run 2
read_seq: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process

read_seq: (groupid=0, jobs=1): err= 0: pid=443: Tue Jun 15 04:23:37 2021
  read: IOPS=28.8k, BW=112MiB/s (118MB/s)(6740MiB/60004msec)
    slat (nsec): min=1620, max=5268.0k, avg=8936.22, stdev=22324.92
    clat (usec): min=159, max=51128, avg=2215.34, stdev=974.52
     lat (usec): min=221, max=51135, avg=2224.47, stdev=974.44
    clat percentiles (usec):
     |  1.00th=[  988],  5.00th=[ 1418], 10.00th=[ 1598], 20.00th=[ 1762],
     | 30.00th=[ 1876], 40.00th=[ 1991], 50.00th=[ 2089], 60.00th=[ 2180],
     | 70.00th=[ 2311], 80.00th=[ 2474], 90.00th=[ 2802], 95.00th=[ 3228],
     | 99.00th=[ 5538], 99.50th=[ 7767], 99.90th=[13698], 99.95th=[16712],
     | 99.99th=[23987]
   bw (  KiB/s): min=77600, max=142760, per=100.00%, avg=115065.58, stdev=13535.36, samples=120
   iops        : min=19400, max=35690, avg=28766.37, stdev=3383.85, samples=120
  lat (usec)   : 250=0.01%, 500=0.05%, 750=0.21%, 1000=0.83%
  lat (msec)   : 2=40.62%, 4=56.09%, 10=1.94%, 20=0.24%, 50=0.02%
  lat (msec)   : 100=0.01%
  cpu          : usr=5.63%, sys=20.34%, ctx=1250392, majf=0, minf=58
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=1725493,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
   READ: bw=112MiB/s (118MB/s), 112MiB/s-112MiB/s (118MB/s-118MB/s), io=6740MiB (7068MB), run=60004-60004msec


======================================= Testing Read Sequential Completed... ============================
====================================== Testing Write Sequential Speed... ================================
Test run 0
write_seq: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process

write_seq: (groupid=0, jobs=1): err= 0: pid=497: Tue Jun 15 04:24:39 2021
  write: IOPS=27.9k, BW=109MiB/s (114MB/s)(6538MiB/60002msec); 0 zone resets
    slat (nsec): min=1780, max=5812.7k, avg=8517.86, stdev=23018.24
    clat (usec): min=226, max=113187, avg=2284.69, stdev=1192.86
     lat (usec): min=240, max=113191, avg=2293.39, stdev=1192.80
    clat percentiles (usec):
     |  1.00th=[ 1106],  5.00th=[ 1549], 10.00th=[ 1713], 20.00th=[ 1893],
     | 30.00th=[ 1991], 40.00th=[ 2089], 50.00th=[ 2180], 60.00th=[ 2278],
     | 70.00th=[ 2376], 80.00th=[ 2540], 90.00th=[ 2802], 95.00th=[ 3130],
     | 99.00th=[ 5407], 99.50th=[ 7242], 99.90th=[11863], 99.95th=[14484],
     | 99.99th=[20841]
   bw (  KiB/s): min=89776, max=125896, per=100.00%, avg=111604.23, stdev=6742.81, samples=120
   iops        : min=22444, max=31474, avg=27900.98, stdev=1685.68, samples=120
  lat (usec)   : 250=0.01%, 500=0.04%, 750=0.14%, 1000=0.38%
  lat (msec)   : 2=29.57%, 4=67.97%, 10=1.72%, 20=0.17%, 50=0.01%
  lat (msec)   : 100=0.01%, 250=0.01%
  cpu          : usr=6.53%, sys=19.39%, ctx=1094544, majf=0, minf=60
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,1673596,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
  WRITE: bw=109MiB/s (114MB/s), 109MiB/s-109MiB/s (114MB/s-114MB/s), io=6538MiB (6855MB), run=60002-60002msec
Test run 1
write_seq: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process
write_seq: Laying out IO file (1 file / 51200MiB)

write_seq: (groupid=0, jobs=1): err= 0: pid=553: Tue Jun 15 04:25:43 2021
  write: IOPS=27.0k, BW=106MiB/s (111MB/s)(6334MiB/60002msec); 0 zone resets
    slat (nsec): min=1762, max=6960.4k, avg=8130.56, stdev=22119.32
    clat (usec): min=216, max=104798, avg=2359.14, stdev=1061.48
     lat (usec): min=270, max=104801, avg=2367.45, stdev=1061.41
    clat percentiles (usec):
     |  1.00th=[ 1237],  5.00th=[ 1647], 10.00th=[ 1795], 20.00th=[ 1958],
     | 30.00th=[ 2073], 40.00th=[ 2180], 50.00th=[ 2245], 60.00th=[ 2343],
     | 70.00th=[ 2442], 80.00th=[ 2606], 90.00th=[ 2868], 95.00th=[ 3195],
     | 99.00th=[ 5669], 99.50th=[ 7308], 99.90th=[11994], 99.95th=[14091],
     | 99.99th=[18744]
   bw (  KiB/s): min=85616, max=137568, per=100.00%, avg=108115.30, stdev=7758.59, samples=120
   iops        : min=21404, max=34392, avg=27028.77, stdev=1939.64, samples=120
  lat (usec)   : 250=0.01%, 500=0.02%, 750=0.08%, 1000=0.26%
  lat (msec)   : 2=22.97%, 4=74.66%, 10=1.82%, 20=0.17%, 50=0.01%
  lat (msec)   : 100=0.01%, 250=0.01%
  cpu          : usr=6.06%, sys=19.33%, ctx=1049127, majf=0, minf=59
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,1621329,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
  WRITE: bw=106MiB/s (111MB/s), 106MiB/s-106MiB/s (111MB/s-111MB/s), io=6334MiB (6641MB), run=60002-60002msec
Test run 2
write_seq: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=64
fio-3.27-16-gdd46
Starting 1 process
write_seq: Laying out IO file (1 file / 51200MiB)

write_seq: (groupid=0, jobs=1): err= 0: pid=609: Tue Jun 15 04:26:46 2021
  write: IOPS=26.9k, BW=105MiB/s (110MB/s)(6297MiB/60002msec); 0 zone resets
    slat (nsec): min=1806, max=8665.4k, avg=8005.15, stdev=19459.75
    clat (usec): min=254, max=93124, avg=2372.86, stdev=1147.79
     lat (usec): min=260, max=93127, avg=2381.03, stdev=1147.64
    clat percentiles (usec):
     |  1.00th=[ 1237],  5.00th=[ 1663], 10.00th=[ 1811], 20.00th=[ 1975],
     | 30.00th=[ 2089], 40.00th=[ 2180], 50.00th=[ 2278], 60.00th=[ 2343],
     | 70.00th=[ 2474], 80.00th=[ 2606], 90.00th=[ 2900], 95.00th=[ 3195],
     | 99.00th=[ 5473], 99.50th=[ 7177], 99.90th=[11994], 99.95th=[14353],
     | 99.99th=[67634]
   bw (  KiB/s): min=85896, max=133296, per=100.00%, avg=107501.29, stdev=8031.84, samples=120
   iops        : min=21474, max=33324, avg=26875.27, stdev=2007.95, samples=120
  lat (usec)   : 500=0.02%, 750=0.09%, 1000=0.22%
  lat (msec)   : 2=21.80%, 4=76.01%, 10=1.68%, 20=0.17%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=6.19%, sys=19.59%, ctx=1032304, majf=0, minf=59
  IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
     issued rwts: total=0,1612075,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=64

Run status group 0 (all jobs):
  WRITE: bw=105MiB/s (110MB/s), 105MiB/s-105MiB/s (110MB/s-110MB/s), io=6297MiB (6603MB), run=60002-60002msec


====================================== Testing Write Sequential Speed Completed... ================================

==================
= FIO bench Summary =
==================
Random Read/Write IOPS: 3741 / 9894. BW(KiB/s): 14950 / 39594.  lat(usec) 17123 / 6534
Sequential Read/Write IOPS: 24633 / 27266. BW(KiB/s) 98508 / 109226. lat(usec) 2669 / 2347
```
