```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get nodes
NAME                                          STATUS    ROLES     AGE       VERSION
gke-demo-openebs-default-pool-4bec5da8-llr5   Ready     <none>    4m        v1.7.8-gke.0
gke-demo-openebs-default-pool-4bec5da8-qf6z   Ready     <none>    4m        v1.7.8-gke.0
gke-demo-openebs-default-pool-4bec5da8-w0t6   Ready     <none>    4m        v1.7.8-gke.0
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get pods
No resources found.
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get svc
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.55.240.1   <none>        443/TCP   5m
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```

