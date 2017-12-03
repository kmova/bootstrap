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

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl config set-context demo-openebs-admin --cluster=gke_strong-eon-153112_us-central1-a_demo-openebs --user=cluster-admin
Context "demo-openebs-admin" created.
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl config use-context demo-openebs-admin
Switched to context "demo-openebs-admin".
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
Please enter Username: admin
Please enter Password: ****************
serviceaccount "openebs-maya-operator" created
clusterrole "openebs-maya-operator" created
clusterrolebinding "openebs-maya-operator" created
deployment "maya-apiserver" created
service "maya-apiserver-service" created
deployment "openebs-provisioner" created
customresourcedefinition "storagepoolclaims.openebs.io" created
customresourcedefinition "storagepools.openebs.io" created
storageclass "openebs-standard" created
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl config use-context gke_strong-eon-153112_us-central1-a_demo-openebs
Switched to context "gke_strong-eon-153112_us-central1-a_demo-openebs".
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```

