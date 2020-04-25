
## Backup 

Create a new single node GKE cluster
```
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
velero install --provider gcp --bucket $BUCKET --secret-file ~/velero/credentials-velero-kmova --use-restic --wait
kubectl apply -f ../openebs-localpv/gke/busybox-localpv-device.yaml
velero backup create bbb-01 -l app=test-ark-backup
velero backup describe bbb-01 --details
velero restic repo get
```
Destroy the cluster

## Restore
Create a new single node GKE cluster
```
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
velero install --provider gcp --bucket $BUCKET --secret-file ~/velero/credentials-velero-kmova --use-restic --wait
kubectl apply -f ../openebs-localpv/gke/busybox-restore-localpv-device.yaml
velero restore create rbb-01 --from-backup bbb-01 -l app=test-ark-backup
```
