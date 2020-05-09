Ref: https://helm.sh/docs/intro/install/


```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

```
kubectl create namespace prometheus-operator
helm install prometheus-operator stable/prometheus-operator -n prometheus-operator --set prometheusOperator.createCustomResource=false grafana.service.type=NodePort
kubectl get pods -n prometheus-operator
kubectl get svc -n prometheus-operator
```


