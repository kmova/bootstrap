#!/bin/bash

function show_help() {
    echo 
    echo "Usage:"
    echo 
    echo "$0 [init|destroy]"
    echo 
    echo "  init     - Initializes a GKE cluster with one Local SSD"
    echo "  destroy  - Deletes the GKE cluster" 
    echo 
    echo "  The cluster will be name kmova-ssd and will be created"
    echo "  in us-central1-a"
    exit 1
}

if [ "$#" -ne 1 ]; then
    show_help
fi

if [ $1 == "init" ]; then
   opts="--zone us-central1-a --image-type UBUNTU"
   opts="$opts --num-nodes 3 --machine-type n1-standard-2"
   opts="$opts --local-ssd-count 1"

   gcloud container clusters create kmova-ssd $opts
   gcloud container clusters get-credentials kmova-ssd --zone us-central1-a
   gcloud info | grep Account
   kubectl create clusterrolebinding kmova-helm-admin-binding --clusterrole=cluster-admin --user=kiran.mova@cloudbyteinc.com
elif [ $1 == "destroy" ]; then
    echo "Destroying cluster kmova-ssd"
    gcloud container clusters delete kmova-ssd --zone us-central1-a 
else
    show_help
fi


