C_VERSION=""
if [ $# -gt 0 ]; then
  C_VERSION=" --cluster-version $1"
fi

C_ZONE=" --zone us-central1-a"
C_TYPE=" --image-type UBUNTU"
C_NODES=" --num-nodes 3"
C_MACHINE=" --machine-type n1-standard-2"


gcloud container clusters create kmova-helm \
 ${C_ZONE} \
 ${C_TYPE} \
 ${C_NODES} \
 ${C_MACHINE} \
 ${C_VERSION}

gcloud container clusters get-credentials kmova-helm \
 ${C_ZONE}

gcloud info | grep Account
kubectl create clusterrolebinding kmova-helm-admin-binding \
 --clusterrole=cluster-admin \
 --user=kiran.mova@mayadata.io
