
## Prerequisties

Setup GCP buckets and IAM roles for executing [Velero with Restic on GCP](/velero/). 

## Setup new cluster with OpenEBS and Velero

Install OpenEBS Local PV components
```
kubectl apply -f https://openebs.github.io/charts/openebs-operator-lite.yaml
kubectl apply -f https://openebs.github.io/charts/openebs-lite-sc.yaml
```

Install Velero

```
velero install --provider gcp --plugins velero/velero-plugin-for-gcp:v1.0.1  --bucket $VELERO_BUCKET --secret-file ~/.velero/credentials-velero --use-restic  --wait
```

## Backup 

Start an application using Local PV. 
```
kubectl apply -f https://openebs.github.io/charts/examples/local-hostpath/local-hostpath-pvc.yaml
kubectl apply -f https://openebs.github.io/charts/examples/local-hostpath/local-hostpath-pod.yaml
```

Prepare the pod for backup. Label and annotate the pod 
```
kubectl label pod hello-local-hostpath-pod app=test-velero-backup
kubectl annotate pod hello-local-hostpath-pod backup.velero.io/backup-volumes=local-storage
```

Backup via restic
```
velero backup create bbb-01 -l app=test-velero-backup
velero backup describe bbb-01 --details
```

On successful completion of the backup, the backup describe will show the following:
```
Restic Backups:
  Completed:
    default/hello-local-hostpath-pod: local-storage
```

Verify Backup is available. 
```
velero restic repo get
```

## Destroy the cluster!

## Create another cluster. 

Install OpenEBS Local PV components
```
kubectl apply -f https://openebs.github.io/charts/openebs-operator-lite.yaml
kubectl apply -f https://openebs.github.io/charts/openebs-lite-sc.yaml
```

Install Velero

```
velero install --provider gcp --plugins velero/velero-plugin-for-gcp:v1.0.1  --bucket $VELERO_BUCKET --secret-file ~/.velero/credentials-velero --use-restic  --wait
```


## Restore

_Important Note: Local PVs are created with node affinity. As the node names change when a new cluster is created, prior to restore - create the required PVCs._

```
kubectl apply -f https://openebs.github.io/charts/examples/local-hostpath/local-hostpath-pvc.yaml
```

Check available backups on remote location. 
```
velero backup get
```

Restore application from backup. 
```
velero restore create rbb-01 --from-backup bbb-01 -l app=test-velero-backup
```

Verify Restore
```
velero restore describe rbb-01
```

On successful restore, the above command should show:
```

Restic Restores (specify --details for more information):
  Completed:  1
```

Check the data from the running pod
```
kubectl exec hello-local-hostpath-pod -- cat /mnt/store/greet.txt
```

The output will show that old data is still present while new data is being written. 
```
Sat Apr 25 15:41:30 UTC 2020 [hello-local-hostpath-pod] Hello from OpenEBS Local PV.
Sat Apr 25 15:46:30 UTC 2020 [hello-local-hostpath-pod] Hello from OpenEBS Local PV.
Sat Apr 25 16:11:25 UTC 2020 [hello-local-hostpath-pod] Hello from OpenEBS Local PV.
```
