
helm install  --namespace openebs --name ut stable/openebs
sleep 20
kubectl get pods -n openebs
sleep 5
kubectl apply -f ./openebs-sc.yaml 
kubectl apply -f https://raw.githubusercontent.com/openebs/openebs/v0.5/k8s/openebs-storageclasses.yaml
kubectl get sc
