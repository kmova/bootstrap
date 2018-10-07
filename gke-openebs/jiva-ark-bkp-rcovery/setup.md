# Setup ARC with Restic on GCP

This document contains quick reference of the installation steps. 

Reference:
 - https://heptio.github.io/ark/v0.9.0/quickstart
 - https://heptio.github.io/ark/v0.9.0/gcp-config

## Setup buckets and IAM roles

### Buckets for ARK backup and Restic data backup.
```
gsutil mb gs://kmova-openebs-ark/
gsutil mb gs://kmova-openebs-ark-restic/
```

### IAM Setup

```
gcloud config list
# Fetch the project id 
export PROJECT_ID=gcp-project-id
```

```
gcloud iam service-accounts create heptio-ark --display-name "Heptio Ark service account"
gcloud iam service-accounts list
export SERVICE_ACCOUNT_EMAIL="heptio-ark@gcp-project-id.iam.gserviceaccount.com"
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
 compute.projects.get
)
```

```
gcloud beta iam roles create heptio_ark.server \
 --project $PROJECT_ID \
 --title "Heptio Ark Server" \
 --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"

gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
 --role projects/$PROJECT_ID/roles/heptio_ark.server

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://kmova-openebs-ark/
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://kmova-openebs-ark-restic/
```


## Download and setup ARK on development host

```
git clone https://github.com/heptio/ark.git
cd ark
git checkout v0.9.5
```

```
vi examples/gcp/00-ark-config.yaml
---
apiVersion: ark.heptio.com/v1
kind: Config
metadata:
  namespace: heptio-ark
  name: default
persistentVolumeProvider:
  name: gcp
backupStorageProvider:
  name: gcp
  bucket: kmova-openebs-ark
  # Uncomment the below line to enable restic integration.
  # The format for resticLocation is <bucket>[/<prefix>],
  # e.g. "my-restic-bucket" or "my-restic-bucket/repos".
  # This MUST be a different bucket than the main Ark bucket
  # specified just above.
  resticLocation: kmova-openebs-ark-restic
backupSyncPeriod: 30m
gcSyncPeriod: 30m
scheduleSyncPeriod: 1m
restoreOnlyMode: false
```

```
wget https://github.com/heptio/ark/releases/download/v0.9.5/ark-v0.9.5-linux-amd64.tar.gz
tar -zxvf ark-v0.9.5-linux-amd64.tar.gz
sudo mv ark /usr/local/bin/
sudo mv ark-restic-restore-helper /usr/local/bin/
```

## Install ARK on GKE Cluster

Go to the checked out ark repo on the development host.

```
kubectl apply -f examples/common/00-prereqs.yaml

#set the SERVICE_ACCOUNT_EMAIL and PROJECT_ID
# using steps above
gcloud iam service-accounts keys create credentials-ark \
 --iam-account $SERVICE_ACCOUNT_EMAIL

kubectl create secret generic cloud-credentials \
 --namespace heptio-ark \
 --from-file cloud=credentials-ark

kubectl apply -f examples/gcp/00-ark-config.yaml

kubectl apply -f examples/gcp/10-deployment.yaml

kubectl apply -f examples/gcp/20-restic-daemonset.yaml
```


