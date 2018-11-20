
This document provides CLI commands for expanding a cStor pool with additional disks. These steps apply to cStor Pools provisioned in 0.7 or 0.8. Pool expansion feature is planned for OpenEBS 0.9.

A single SPC can result in one or more cStor pools depending on the disks provided to SPC spec. A cStor Pool comprises of
- Storage Pool CR (SP) - used for specifying the Disk CRs used by the pool.
- cStor Storage Pool CR (CSP) - used for specifying the unique disk path used by the pool.
- cStor Storage Pool Deployment and associated Pod. 

When the SPC spec is created with a set of disks, the cstor-operator will segregate the disks based on the node. And on each node, a cStor Pool will be created using the disks from that node. Once cStor Pools are provisioned, the cstor-operator will have to monitor for the updates to the SPC spec and check for any new disks provided. If a new disk is provided, it has to identify the node and pool and add the disk to that pool. 

The following steps are per cStor Storage Pool and will need to be repeated on each of the cStor Pools corresponding to an SPC. 


A Pool can be expanded only by the disks already discovered on the same node. 

### Step 1: Identify the cStor Pool (CSP) and Storage Pool (SP) associated with the SPC. 

  `kubectl get sp -l openebs.io/storage-pool-claim=cstor-disk --show-labels`

  Storage Pools sample output:
  ```
  NAME              AGE       LABELS
  cstor-disk-i4xj   53m       kubernetes.io/hostname=gke-kmova-helm-default-pool-2c01cdf6-9mxq,openebs.io/cas-type=cstor,openebs.io/cstor-pool=cstor-disk-i4xj,openebs.io/storage-pool-claim=cstor-disk
  cstor-disk-vt1u   53m       kubernetes.io/hostname=gke-kmova-helm-default-pool-2c01cdf6-dxbf,openebs.io/cas-type=cstor,openebs.io/cstor-pool=cstor-disk-vt1u,openebs.io/storage-pool-claim=cstor-disk
  cstor-disk-ys0r   53m       kubernetes.io/hostname=gke-kmova-helm-default-pool-2c01cdf6-nh6w,openebs.io/cas-type=cstor,openebs.io/cstor-pool=cstor-disk-ys0r,openebs.io/storage-pool-claim=cstor-disk
  ```
  
  From the above list, pick up the cStor Pool that needs to be expanded. The name of both CSP and SP will be same. The rest of the steps assume that `cstor-disk-vt1u` needs to be expanded. 
  From the above output, also note down the node on which the Pool is running. In this case the node is `gke-kmova-helm-default-pool-2c01cdf6-dxbf`

### Step 2: Identify the new disk that that need to be attached to the cStor Pool. 

  The following command can be used to list the disks on a give node. 
  `kubectl get disks -l kubernetes.io/hostname=gke-kmova-helm-default-pool-2c01cdf6-dxbf`

  Sample Disks Output.
  ```
  NAME                                      AGE
  disk-b407e5862d253e666636f2fe5a01355d     46m
  disk-ffca7a8731976830057238c5dc25e94c     46m
  sparse-ed5a5183d2dba23782d641df61a1d869   52m
  ```

  The following command can be used to see the disks already used on the node - gke-kmova-helm-default-pool-2c01cdf6-dxbf
  `kubectl get sp -l kubernetes.io/hostname=gke-kmova-helm-default-pool-2c01cdf6-dxbf -o jsonpath="{range .items[*]}{@.spec.disks.diskList};{end}" | tr ";" "\n"`

  Sample Output:
  ```
  [disk-b407e5862d253e666636f2fe5a01355d]
  [sparse-ed5a5183d2dba23782d641df61a1d869]`
  ```

  In this case, `disk-ffca7a8731976830057238c5dc25e94c` is unused. 

### Step 3: Patch CSP with the disk path details
  Get the disk path listed by unique path under devLinks. 

  `kubectl get disk disk-ffca7a8731976830057238c5dc25e94c -o jsonpath="{range .spec.devlinks[0]}{@.links[0]};{end}" | tr ";" "\n"`
 
  Sample Output:
  ```
  /dev/disk/by-id/scsi-0Google_PersistentDisk_kmova-n2-d1
  ```

  Patch the above disk path into CSP
  ```
  kubectl patch csp cstor-disk-vt1u --type json -p '[{ "op": "add", "path": "/spec/disks/diskList/-", "value": "/dev/disk/by-id/scsi-0Google_PersistentDisk_kmova-n2-d1" }]'
  ```

  Verify that disk is patched by executing `kubectl get csp cstor-disk-vt1u -o yaml` and check that new disk is added under diskList.


### Step 4: Patch SP with disk name

  The following command patches the SP (cstor-disk-vt1u) with disk (disk-ffca7a8731976830057238c5dc25e94c)
  ```
  kubectl patch sp cstor-disk-vt1u --type json -p '[{ "op": "add", "path": "/spec/disks/diskList/-", "value": "disk-ffca7a8731976830057238c5dc25e94c" }]'
  ```

  Verify that disk is patched by executing `kubectl get sp cstor-disk-vt1u -o yaml` and check that new disk is added under diskList.

### Step 5: Expand the pool.

  The last step is to update the cstor pool pod (cstor-disk-vt1u) with disk path (/dev/disk/by-id/scsi-0Google_PersistentDisk_kmova-n2-d1)
  
  Identify the cstor pool pod associated with CSP cstor-disk-vt1u.
  `kubectl get pods -n openebs | grep cstor-disk-vt1u`

  Sample Output:

  ```
  cstor-disk-vt1u-65b659d574-8f6fp            2/2       Running   0          1h        10.44.1.8    gke-kmova-helm-default-pool-2c01cdf6-dxbf
  ```

  Check the pool name: `kubectl exec -it -n openebs cstor-disk-vt1u-65b659d574-8f6fp -- zpool list`

  Sample Output:

  ```
  NAME                                         SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
  cstor-deaf87e6-ec78-11e8-893b-42010a80003a   496G   202K   496G         -     0%     0%  1.00x  ONLINE  -
  ```

  Extract the pool name from above output. In this case - cstor-deaf87e6-ec78-11e8-893b-42010a80003a

  Expand the pool with additional disk. 

  `kubectl exec -it -n openebs cstor-disk-vt1u-65b659d574-8f6fp -- zpool add cstor-deaf87e6-ec78-11e8-893b-42010a80003a /dev/disk/by-id/scsi-0Google_PersistentDisk_kmova-n2-d1`


  You can execute the list command again to see the increase in capacity. 
  `kubectl exec -it -n openebs cstor-disk-vt1u-65b659d574-8f6fp -- zpool list`

  Sample Output:

  ```
  NAME                                         SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
  cstor-deaf87e6-ec78-11e8-893b-42010a80003a   992G   124K   992G         -     0%     0%  1.00x  ONLINE  -
  ```

