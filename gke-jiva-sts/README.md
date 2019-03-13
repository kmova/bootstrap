kubectl apply -f openebs-operator-0.8.2-ci.yaml 
kubectl apply -f local-path-storage.yaml
kubectl create namespace local-path-storage

kubectl apply -f jiva-volume-create-putreplicasts-default-0.8.1.yaml
kubectl apply -f jiva-volume-create-sts-0.8.1.yaml
kubectl apply -f sc-jiva-sts.yaml

kubectl apply -f pvc-jiva-sts.yaml 
kubectl exec -it busybox /bin/sh
