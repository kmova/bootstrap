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
