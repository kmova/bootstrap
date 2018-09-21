Follow the instructions in [setup.md](./setup.md) to install ark with restic support.

The backup and restore example below is derived from samples provided in [arc-restic-docs](https://heptio.github.io/ark/v0.9.0/restic#setup)


### Setup OpenEBS and a sample application

```
kubectl apply -f https://openebs.github.io/charts/openebs-operator-0.7.0.yaml
kubectl apply -f busybox.yaml
kubectl annotate pod/busybox backup.ark.heptio.com/backup-volumes=demo-vol1

#Write some data into /mnt/store1
kubectl exec -it busybox /bin/bash

kubectl get pods -l app=test-ark-backup
```

### Backup 

```
ark backup create backup-03 -l app=test-ark-backup

#Verify
ark backup describe backup-03
gsutil ls gs://kmova-openebs-ark-restic/default/
gsutil ls gs://kmova-openebs-ark/backup-03
```

### Destroy cluster or the application along with its PVC

```
kubectl delete -f busybox.yaml
```


### Recreate cluster and setup ARK and OpenEBS

Follow subset of the instructions from creating secret and deploying ark components from [setup.md](./setup.md)

```
kubectl apply -f https://openebs.github.io/charts/openebs-operator-0.7.0.yaml
```

### Restore
```
kubectl apply -f busybox-restore-pvc.yaml
ark restore create restore-03 --from-backup backup-03 -l app=test-ark-backup
```


