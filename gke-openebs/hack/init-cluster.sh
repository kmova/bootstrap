gcloud container clusters create kmova-helm --zone us-central1-a --image-type UBUNTU --num-nodes 3 --machine-type n1-standard-2
gcloud container clusters get-credentials kmova-helm --zone us-central1-a
gcloud info | grep Account
kubectl create clusterrolebinding kmova-helm-admin-binding --clusterrole=cluster-admin --user=kiran.mova@cloudbyteinc.com
