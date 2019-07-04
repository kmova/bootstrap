```
mkdir -p ~/velero; cd ~/velero
wget https://github.com/heptio/velero/releases/download/v1.0.0/velero-v1.0.0-linux-arm64.tar.gz
tar -xvf velero-v1.0.0-linux-amd64.tar.gz -C ~/velero
```

```
.profile > PATH="$HOME/velero/velero-v1.0.0-linux-arm64:$PATH"
```

```
gsutil mb gs://kmova-openebs-velero/
#gsutil mb gs://kmova-openebs-velero-restic/
gcloud iam service-accounts create velero-kmova --display-name "Velero kmova service account"
```

```
export BUCKET="kmova-openebs-velero"
export PROJECT_ID="strong-eon-153112"
export SERVICE_ACCOUNT_EMAIL="velero-kmova@strong-eon-153112.iam.gserviceaccount.com"
```

```
ROLE_PERMISSIONS=( 
 compute.disks.get 
 compute.disks.create
 compute.disks.createSnapshot
 compute.snapshots.get
 compute.snapshots.create
 compute.snapshots.useReadOnly
 compute.snapshots.delete
 compute.zones.get
)
```


```
gcloud iam roles create velerokmova.server \
 --project $PROJECT_ID \
 --title "Velero Kmova Server" \
 --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"    
```

```
gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
 --role projects/$PROJECT_ID/roles/velerokmova.server
```

```
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://${BUCKET}
#gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://kmova-openebs-velero-restic/
```

```
gcloud iam service-accounts keys create credentials-velero-kmova \
 --iam-account $SERVICE_ACCOUNT_EMAIL
mv credentials-velero-kmova ~/velero
```

```
velero install --provider gcp --bucket $BUCKET --secret-file ~/velero/credentials-velero-kmova --use-restic --wait
```
