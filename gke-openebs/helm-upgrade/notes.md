helm install  --namespace openebs --name ut stable/openebs
kubectl get pods -n openebs

/tmp/openebs-sc.yaml
kubectl apply -f /tmp/openebs-sc.yaml 
kubectl apply -f https://raw.githubusercontent.com/openebs/openebs/v0.5/k8s/openebs-storageclasses.yaml
kubectl get sc

kubectl create namespace percona-test 
kubectl apply -f https://raw.githubusercontent.com/kmova/bootstrap/master/gke-openebs/demo-percona/percona-openebs-deployment.yaml
kubectl get pvc -n percona-test
kubectl get pods -n percona-test

helm ls
helm upgrade -f https://openebs.github.io/charts/helm-values-0.6.0.yaml ut stable/openebs
kubectl get pods -n openebs


kubectl get deploy -n percona-test
kubectl delete deploy -n percona-test percona

