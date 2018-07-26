kubectl create namespace percona-test 
kubectl apply -f https://raw.githubusercontent.com/kmova/bootstrap/master/gke-openebs/demo-percona/percona-openebs-deployment.yaml
kubectl get pvc -n percona-test
kubectl get pods -n percona-test
