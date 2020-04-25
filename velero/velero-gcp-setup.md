# Setup Velero with Restic on GCP

This document contains quick reference for setting up Velero with Restic on GCP

Reference: https://github.com/vmware-tanzu/velero-plugin-for-gcp#setup

## Setup GCP buckets 

The buckets will be used for storing application and volume backup

```
export VELERO_BUCKET=<YOUR_BUCKET>
#export VELERO_BUCKET="kmova-openebs-velero"
gsutil mb gs://${VELERO_BUCKET}/
gsutil mb gs://${VELERO_BUCKET}-restic/
```

### Verify

```
gsutil ls -b gs://${VELERO_BUCKET}
gsutil ls -b gs://${VELERO_BUCKET}-restic
```

## Set permissions on GCP Buckets for Velero

### Save PROJECT_ID

```
gcloud config list
# Example output
# [core]
# account = <user email>
# project = <gcp project id>
export PROJECT_ID=<gcp_project_id>
```


### Setup Service Account 

```
export VELERO_SERVICE_ACCOUNT=<account name>
#export VELERO_SERVICE_ACCOUNT="velero-kmova"
gcloud iam service-accounts create VELERO_SERVICE_ACCOUNT --display-name "Service account for velero"
export VELERO_SERVICE_ACCOUNT_EMAIL="${VELERO_SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com"
```

#### Verify Service account exists

```
gcloud iam service-accounts describe $VELERO_SERVICE_ACCOUNT_EMAIL
```

### Attach IAM policies to Velero service account. 

```
export VELERO_ROLES=<unique role name>
#export VELERO_ROLES="velerokmova.server"

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

gcloud iam roles create ${VELERO_ROLES} \
 --project $PROJECT_ID \
 --title "Velero Server for ${VELERO_BUCKET}" \
 --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"    

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member serviceAccount:${VELERO_SERVICE_ACCOUNT_EMAIL} \
 --role projects/$PROJECT_ID/roles/${VELERO_ROLES}

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://${VELERO-BUCKET}
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://${VELERO-BUCKET}-restic/
```

## Install

### Setup environment variables
```
export VELERO_BUCKET=<YOUR_BUCKET>
export PROJECT_ID=<gcp_project_id>
export VELERO_SERVICE_ACCOUNT=<account name>
#export VELERO_SERVICE_ACCOUNT="velero-kmova"
export VELERO_SERVICE_ACCOUNT_EMAIL="${VELERO_SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com"
#export VELERO_BUCKET="kmova-openebs-velero"

```
### Create credentials-velero file to be used with velero install
```
gcloud iam service-accounts keys create credentials-velero --iam-account $VELERO_SERVICE_ACCOUNT_EMAIL
mkdir -p $HOME/.velero/
mv credentials-velero $HOME/.velero/
```

### Download 

```
wget https://github.com/vmware-tanzu/velero/releases/download/v1.3.2/velero-v1.3.2-linux-amd64.tar.gz
tar -xvf velero-v1.3.2-linux-amd64.tar.gz
sudo mv velero-v1.3.2-linux-amd64/velero /usr/local/bin/
```


### Install with restic
```
velero install \
 --provider gcp \
 --plugins velero/velero-plugin-for-gcp:v1.0.1 \
 --bucket $VELERO_BUCKET \
 --secret-file ~/.velero/credentials-velero \
 --use-restic  --wait
```
