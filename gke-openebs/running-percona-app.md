```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get sc openebs-standard -o yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{},"name":"openebs-standa
rd","namespace":""},"parameters":{"openebs.io/capacity":"5G","openebs.io/jiva-replica-count":"2","openebs.io/stor
age-pool":"default","openebs.io/volume-monitor":"true"},"provisioner":"openebs.io/provisioner-iscsi"}
  creationTimestamp: 2017-12-03T14:30:27Z
  name: openebs-standard
  resourceVersion: "1465"
  selfLink: /apis/storage.k8s.io/v1/storageclasses/openebs-standard
  uid: 818cd26d-d836-11e7-9caa-42010a8000a7
parameters:
  openebs.io/capacity: 5G
  openebs.io/jiva-replica-count: "2"
  openebs.io/storage-pool: default
  openebs.io/volume-monitor: "true"
provisioner: openebs.io/provisioner-iscsi
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ vi openebs-percona-sc.yaml
kiran_mova@kmova-dev:~/infra/demo-openebs$ cat openebs-percona-sc.yaml 
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: openebs-percona
parameters:
  openebs.io/capacity: 5G
  openebs.io/jiva-replica-count: "2"
  openebs.io/storage-pool: default
  openebs.io/volume-monitor: "true"
provisioner: openebs.io/provisioner-iscsi
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ vi percona-with-openebs.yaml 
kiran_mova@kmova-dev:~/infra/demo-openebs$ cat percona-with-openebs.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: percona
  labels:
    name: percona
spec:
  containers:
  - resources:
      limits:
        cpu: 0.5
    name: percona
    image: percona
    args:
      - "--ignore-db-dir"
      - "lost+found"
    env:
      - name: MYSQL_ROOT_PASSWORD
        value: k8sDem0
    ports:
      - containerPort: 3306
        name: percona
    volumeMounts:
    - mountPath: /var/lib/mysql
      name: percona-db-vol
  volumes:
  - name: percona-db-vol
    persistentVolumeClaim:
      claimName: percona-db-vol-claim
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: percona-db-vol-claim
spec:
  storageClassName: openebs-percona
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5G
kiran_mova@kmova-dev:~/infra/demo-openebs$
```

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl apply -f openebs-percona-sc.yaml 
storageclass "openebs-percona" created
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl apply -f percona-with-openebs.yaml 
pod "percona" created
persistentvolumeclaim "percona-db-vol-claim" created
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get pods
NAME                                                            READY     STATUS              RESTARTS   AGE
maya-apiserver-2288016177-qh7sx                                 1/1       Running             0          15m
openebs-grafana-2789105701-1plmf                                1/1       Running             0          12m
openebs-prometheus-4109589487-w1j6l                             1/1       Running             0          12m
openebs-provisioner-2835097941-8hpts                            1/1       Running             0          15m
percona                                                         0/1       ContainerCreating   0          36s
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-ctrl-696530238-ngrgj   2/2       Running             0          36s
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep-3408218758-2ldzv   1/1       Running             0          36s
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep-3408218758-6mwj5   1/1       Running             0          36s
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get svc
NAME                                                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)            AGE
kubernetes                                          ClusterIP   10.55.240.1     <none>        443/TCP            27m
maya-apiserver-service                              ClusterIP   10.55.250.40    <none>        5656/TCP           15m
openebs-grafana                                     NodePort    10.55.242.8     <none>        3000:32515/TCP     12m
openebs-prometheus-service                          NodePort    10.55.249.80    <none>        80:32514/TCP       12m
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-ctrl-svc   ClusterIP   10.55.247.152   <none>        3260/TCP,9501/TCP  44s
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```


```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get pods
NAME                                                            READY     STATUS    RESTARTS   AGE
maya-apiserver-2288016177-qh7sx                                 1/1       Running   0          16m
openebs-grafana-2789105701-1plmf                                1/1       Running   0          14m
openebs-prometheus-4109589487-w1j6l                             1/1       Running   0          14m
openebs-provisioner-2835097941-8hpts                            1/1       Running   0          16m
percona                                                         1/1       Running   0          1m
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-ctrl-696530238-ngrgj   2/2       Running   0          1m
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep-3408218758-2ldzv   1/1       Running   0          1m
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep-3408218758-6mwj5   1/1       Running   0          1m
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get deploy
NAME                                            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
maya-apiserver                                  1         1         1            1           16m
openebs-grafana                                 1         1         1            1           14m
openebs-prometheus                              1         1         1            1           14m
openebs-provisioner                             1         1         1            1           16m
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-ctrl   1         1         1            1           2m
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep    2         2         2            2           2m
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```
