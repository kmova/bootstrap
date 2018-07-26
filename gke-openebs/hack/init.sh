gcloud container clusters get-credentials kmova-helm --zone us-central1-a
gcloud info | grep Account
kubectl create clusterrolebinding kmova-helm-admin-binding --clusterrole=cluster-admin --user=kiran.mova@cloudbyteinc.com
helm init
sleep 20
helm version
