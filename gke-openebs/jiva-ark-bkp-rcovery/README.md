Follow the instructions in [setup.md](./setup.md) to install ark with restic support.

The backup and restore example below is derived from samples provided in [arc-restic-docs](https://heptio.github.io/ark/v0.9.0/restic#setup)


### Setup OpenEBS and a sample application

```
kubectl apply -f https://openebs.github.io/charts/openebs-operator-0.7.0.yaml
kubectl apply -f busybox.yaml

#Write some data into /mnt/store1
kubectl exec -it busybox /bin/bash

kubectl get pods -l app=test-ark-backup
```

### Backup 

```
Issue 1: It appears that the data written from the pods is not visible
in the restic daemonset pod on the same node. Possibly due to k8s version (1.9.7)
issue with mount propogation?

Workaround: delete the restic pod. After it restarts, the data is visible.


```

```
ark backup create bbb-01 -l app=test-ark-backup

#Verify
ark backup describe bbb-01
gsutil ls gs://kmova-openebs-ark-restic/default/
gsutil ls gs://kmova-openebs-ark/bbb-01
```

### Destroy cluster or the application along with its PVC

```
kubectl delete -f busybox.yaml
```


### (Optional) Recreate cluster and setup ARK and OpenEBS

Follow subset of the instructions from creating secret and deploying ark components from [setup.md](./setup.md)

```
kubectl apply -f https://openebs.github.io/charts/openebs-operator-0.7.0.yaml
```

### Restore
```
kubectl apply -f busybox-restore-pvc.yaml
ark restore create rbb-01 --from-backup bbb-01 -l app=test-ark-backup
ark restore describe rbb-01 --volume-details
```

```
Issue 2: The restored data is available within in the hostdir of the restic pod.
However it is not visible on the host or in the restored pod. Similar to the issue 
above. 
(Ref: https://github.com/heptio/ark/issues/669)

Workaround: Copy the contents from the downloaded dir in restic pod, to the scratch 
folder. And the move the contents along with .ark folder into the 
/var/lib/kubelet/restore-pod-id/../mount.
```


