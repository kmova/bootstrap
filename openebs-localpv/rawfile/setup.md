## Configuration 

- **Important**. Setup the location where the sparse files should be created in rawfile-csi.yaml. The default is `/var/csi/rawfile`.
  In the current version, this directory is hard-coded.  Mount your desired device to the default location as shown below. 
  ```
  sudo mkfs.xfs /dev/nvme0n3
  sudo mkdir -p /var/csi/rawfile
  sudo mount /dev/nvme0n3 /var/csi/rawfile
  ```

- For air-gapped environment, you will need to mirror the below images and also update the ENV variables `IMAGE_TAG` and `IMAGE_REPOSITORY`.  
  ```
  quay.io/k8scsi/csi-node-driver-registrar:v1.2.0
  quay.io/k8scsi/csi-provisioner:v1.6.0
  quay.io/k8scsi/csi-resizer:v0.5.0
  docker.io/openebs/rawfile-localpv:ci-3e0a780
  ```
 

## Setup

- Launch the rawfile csi driver `kubectl apply -f rawfile-csi.yaml`
- Create Storage Class `kubectl apply -f sc.yaml`

## Usage

- Create a test pod. `kubectl apply -f example-busybox.yaml`

- Verify that pods are able to access and write. 
  `kubectl exec -it busybox -- cat /mnt/store1/date.txt`
  
