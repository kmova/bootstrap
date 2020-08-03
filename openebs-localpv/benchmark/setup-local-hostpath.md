This page contains instructions to customize the paths used for OpenEBS Local PV hostpath and OpenEBS Rawfile Local PV. 

- Let us assume that you want to store the OpenEBS Local PV Rawfile under "/mnt/disks/ssd0/sparse" 

- Edit the [openebs-operator-lite.yaml](./openebs-operator-lite.yaml), replace "/var/openebs/sparse" with "/mnt/disks/ssd0/sparse"

- Edit the openebs-operator-lite.yaml, specify the size of the sparsefile to be created and the number of sparse files.
  For example, the following values will create 2 sparse files with 100G each.
  ```
        - name: SPARSE_FILE_DIR
          value: "/mnt/disks/ssd0/sparse"
        # Size(bytes) of the sparse file to be created.
        - name: SPARSE_FILE_SIZE
          value: "107374182400"
        # Specify the number of sparse files to be created
        - name: SPARSE_FILE_COUNT
          value: "2"
   ```

- Apply Local PV provisioner and NDM components. `kubectl apply -f openebs-operator-lite.yaml` 

- Verify the sparse files are created. OpenEBS pods should be initialized prior to creating the sparse BDs.
  `kubectl get bd -n openebs -o wide`

- Create a hostpath storage class. This will help to compare between openebs-hostpath and openebs-rawfile. 
  - Edit [openebs-hostpath-sc.yaml](./openebs-hostpath-sc.yaml) and set the `BasePath` to point to a directory on the node. Example: `/mnt/disks/ssd0/local/`
  - `kubectl apply -f openebs-hostpath-sc.yaml`

- Create rawfile storage class. (Note that the following steps will change when the CSI driver for raw file is used. These steps will help to run benchmark tests on rawfile. 

  - `kubectl apply -f openebs-rawfile-sc.yaml`
  - Create a static local pv for the sparse disk created by NDM in the cluster. You can get the list of sparse disks by `kubectl get bd -n openebs -o wide`.
  - Login to the node, format and mount the sparse file. For example: 
    * sudo mkdir -p /mnt/sparse/disk-0
    * sudo mkfs.xfs /mnt/disks/ssd0/sparse/0-ndm-sparse.img
    * sudo mount /mnt/disks/ssd0/sparse/0-ndm-sparse.img /mnt/sparse/disk-0
  - Edit static-pv-rawfile.yaml, change the path of the sparse disk (/mnt/sparse/disk-0) and the node name.
  - `kubectl apply -f static-pv-rawfile.yaml`
  - If you would like to run pods on multiple nodes with the openebs-rawfile, create additional static-rawfile PVs.

- You can now use either `openebs-hostpath` or `openebs-rawfile` as StorageClass for your benchmarking pod. 
  - Example see [quick-bench.yaml](./quick-bench.yaml)
  - `kubectl get pods` => should show the bench pod running
  - `kubectl get pvc` => should show the bench-pvc bound to required type
  - `kubectl logs -f <bench-pod>` => will contain the results of the quick bench test with containerized fio.

- Cleanup using the following commands before running the bench test again:
  - `kubectl delete job bench`
  - `kubectl delete pvc bench-pv-claim`

- For re-running the test on rawfile pv, delete the release pv and re-apply. 
  - `kubectl delete -f static-pv-rawfile.yaml`
  - `kubectl apply -f static-pv-rawfile.yaml`


  




  
