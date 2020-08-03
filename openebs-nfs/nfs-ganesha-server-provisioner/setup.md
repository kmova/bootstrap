## Configuration 

- Edit the `image` location in `deployment.yaml` to the registry location specified while building the container.
- Edit the `provisioner` argument in the `args` field in `deployment.yaml` to be the provisioner's name you decided on.
- Edit the backing storage for provisioner. Note that the volume mounted there must have a [supported file system](https://github.com/nfs-ganesha/nfs-ganesha/wiki/Fsalsupport#vfs) on it: any local filesystem on Linux is supported & NFS is not supported.

## Setup

- Launch the NFS Server and Provisioner `kubectl apply -f psp.yaml -f rbac.yaml -f deployment.yaml`
- Create Storage Class `kubectl apply -f class.yaml`

## Usage

- Create a NFS Claim and multiple pods to access them. `kubectl apply -f example-claim.yaml -f example-busybox-rc.yaml`

- Verify that pods are able to access and write. 
  
  Example:
  ```
  kubectl exec -it nfs-provisioner-694f5f9c88-pd59d -- ls /export
  kubectl exec -it nfs-provisioner-694f5f9c88-pd59d -- ls /export/pvc-7341cb3b-3d45-40be-b2c4-ea83ed38ab4f/index.html
  kubectl exec -it nfs-provisioner-694f5f9c88-pd59d -- cat /export/pvc-7341cb3b-3d45-40be-b2c4-ea83ed38ab4f/index.html
  ```

