Follow the instructions in [setup.md](./setup.md) to install ark with restic support.

The backup and restore example below is derived from samples provided in [arc-restic-docs](https://heptio.github.io/ark/v0.9.0/restic#setup)


### Setup OpenEBS and a sample application

```
kubectl apply -f https://openebs.github.io/charts/openebs-operator-0.7.0.yaml
kubectl apply -f busybox.yaml

#Write some data into /mnt/store1
kubectl exec -it busybox /bin/sh

kubectl get pods -l app=test-ark-backup
```

### Backup 

```
#Login to restic pod on the node where busy box is running
#Check data is visible in the following directory:
# /host_pods/<busybox-pod-id>/volumes/kubernetes.io~iscsi/<pod-name>
```

```
Issue 1: If using K8s 1.10.7 or earlier, the data written from the pods
will not visible in the restic daemonset pod on the same node. This
feature requires - mount-propogration feature to be enabled in k8s. 

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
Issue 2: If using k8s versions prior 1.10.7, the restor command
fetches the data into hostdir, but will not be visible under the 
busybox pod. 
(Ref: https://github.com/heptio/ark/issues/669)

Workaround: Copy the contents from the downloaded dir in restic pod,
 to the scratch folder. And the move the contents along with .ark 
folder into the /var/lib/kubelet/restore-pod-id/../mount.
```


