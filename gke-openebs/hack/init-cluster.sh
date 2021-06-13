#gcloud container get-server-config --zone us-central1-a
#C_VERSION=" --cluster-version 1.12.5-gke.5"
#C_VERSION=" --cluster-version 1.14.10-gke.17"
#C_VERSION=" --cluster-version 1.15.11-gke.13"
#C_VERSION=" --cluster-version 1.16.9-gke.6"
#C_VERSION=" --cluster-version 1.16.13-gke.1"
if [ $# -gt 0 ]; then
  C_VERSION=" --cluster-version $1"
fi
C_VERSION=" "

C_ZONE=" --zone us-central1-a"
C_TYPE=" --image-type UBUNTU"
C_NODES=" --num-nodes 3"
C_MACHINE=" --machine-type n1-standard-2"
C_LOCALSSD=" --local-ssd-count 2"


gcloud container clusters create kmova-helm \
 ${C_ZONE} \
 ${C_TYPE} \
 ${C_NODES} \
 ${C_MACHINE} \
 ${C_LOCALSSD} \
 ${C_VERSION}

gcloud container clusters get-credentials kmova-helm \
 ${C_ZONE} \
 --project ${PROJECT_ID}


#gcloud container clusters get-credentials cluster-1 --zone us-central1-c --project strong-eon-153112
gcloud info | grep Account

kubectl create clusterrolebinding kmova-helm-admin-binding \
 --clusterrole=cluster-admin \
 --user=kiran.mova@mayadata.io
