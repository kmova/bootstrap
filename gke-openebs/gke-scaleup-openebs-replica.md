```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get deploy
NAME                                            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
maya-apiserver                                  1         1         1            1           1h
openebs-grafana                                 1         1         1            1           1h
openebs-prometheus                              1         1         1            1           1h
openebs-provisioner                             1         1         1            1           1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-ctrl   1         1         1            1           1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep    2         2         2            2           1h
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl scale --current-replicas=2 --replicas=3 deployment/pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep
deployment "pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep" scaled
kiran_mova@kmova-dev:~/infra/demo-openebs$
```

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get deploy
NAME                                            DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
maya-apiserver                                  1         1         1            1           1h
openebs-grafana                                 1         1         1            1           1h
openebs-prometheus                              1         1         1            1           1h
openebs-provisioner                             1         1         1            1           1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-ctrl   1         1         1            1           1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep    3         3         3            3           1h
kiran_mova@kmova-dev:~/infra/demo-openebs$ 
```

```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl get pods
NAME                                                            READY     STATUS    RESTARTS   AGE
maya-apiserver-2288016177-qh7sx                                 1/1       Running   0          1h
openebs-grafana-2789105701-1plmf                                1/1       Running   0          1h
openebs-prometheus-4109589487-w1j6l                             1/1       Running   0          1h
openebs-provisioner-2835097941-8hpts                            1/1       Running   0          1h
percona                                                         1/1       Running   0          1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-ctrl-696530238-ngrgj   2/2       Running   1          1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep-3408218758-2ldzv   1/1       Running   0          1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep-3408218758-6mwj5   1/1       Running   0          1h
pvc-8a9fc4b1-d838-11e7-9caa-42010a8000a7-rep-3408218758-nxq47   1/1       Running   0          2m
kiran_mova@kmova-dev:~/infra/demo-openebs$
```
