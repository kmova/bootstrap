## Example Statefulset using OpenEBS Local PV with Device. 


- Label the block devices to be used for Local PV, using command like:
  ```
  kubectl label bd -n openebs blockdevice-0bda0b6faf30fbd065808a310adb0f35 openebs.io/block-device-tag=fio-job`
  ```
  
  In my cluster, I went ahead and tagged 3 block devices from 3 different nodes with tag named "fio-job"

  After tags are created, I verified using:
    
  ```
  kmova-dev:~$ kubectl get bd -n openebs -l "openebs.io/block-device-tag=fio-job"
 
  NAME                                           NODENAME                                    SIZE           CLAIMSTATE   STATUS   AGE
  blockdevice-0bda0b6faf30fbd065808a310adb0f35   gke-kmova-helm-default-pool-6597c2bc-n9kn   402653184000   Unclaimed    Active   10m
  blockdevice-1858dd2be6e703008ed9e7110b7dd287   gke-kmova-helm-default-pool-6597c2bc-wj7k   402653184000   Unclaimed    Active   10m
  blockdevice-4a521c3a0d8e0391c9c80fd1f1802973   gke-kmova-helm-default-pool-6597c2bc-1gpt   402653184000   Unclaimed    Active   10m
  ```

- Create a storage class that uses the block device tag. 
 
  ```
  kubectl apply -f sc-openebs-local-sts.yaml
  ```

  The storage class YAML is [here](./sc-openebs-local-sts.yaml).

- Apply a Statefulset that uses local pv using the above storage class.

  ```
  kubectl apply -f busybox-sts-localpv.yaml
  ```
  
  The STS YAML is [here](./busybox-sts-localpv.yaml).

- Kubernetes will create a new PV for each pod created for the Statefulset. By default, K8s will scheduled the pods to different nodes depending on the CPU and RAM resources. In best case, the pods will be scheduled onto different nodes. Example output. 

  ```
  kmova-dev:~$ kubectl get pods -o wide
  NAME                  READY   STATUS    RESTARTS   AGE   IP          NODE                                        NOMINATED NODE   READINESS GATES
  busybox-local-sts-0   1/1     Running   0          35s   10.44.2.9   gke-kmova-helm-default-pool-6597c2bc-wj7k   <none>           <none>
  busybox-local-sts-1   1/1     Running   0          27s   10.44.0.9   gke-kmova-helm-default-pool-6597c2bc-1gpt   <none>           <none>
  busybox-local-sts-2   1/1     Running   0          19s   10.44.1.6   gke-kmova-helm-default-pool-6597c2bc-n9kn   <none>           <none>
  ```
    			
### Known Limitations:
- The scheduling is only based on the RAM and CPU. In case K8s schedules the pod to a node where the devices are exhausted, then the pod will remain in pending state. 
- The scheduling can result in more than one pod getting scheduled to same node due to the CPU/RAM constraints. To avoid this, pod anti affinity should be set on the Statefulset.
- When a STS and its pods are deleted, the associated PVCs are not automatically deleted by Kubernetes. A manual cleanup of the PVCs is required. 

