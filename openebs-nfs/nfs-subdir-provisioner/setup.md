## Configuration

- Edit the `image` location in `deployment.yaml` to the registry location specified while building the container.
- Edit the `provisioner` argument in the `args` field in `deployment.yaml` to be the provisioner's name you decided on.
- Edit the NFS server and path in the `deployment.yaml`. For example, a NFS Ganesha server and a Volume can be used for using in-cluster storage. 

## Setup

- Launch the NFS sub directory provisioner. `kubectl apply -f rbac.yaml -f deployment.yaml`
- Create Storage class.  `kubectl apply -f class.yaml`

## Usage

- Launch test claim and pod. `kubectl apply -f test-claim.yaml -f test-pod.yaml`
- Verify. 
  `kubectl exec -it nfs-provisioner-694f5f9c88-pd59d -- ls /export/pvc-7341cb3b-3d45-40be-b2c4-ea83ed38ab4f/`

