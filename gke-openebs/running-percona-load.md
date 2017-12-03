```
kiran_mova@kmova-dev:~/infra/demo-openebs$ kubectl describe pod percona | more
Name:         percona
Namespace:    default
Node:         gke-demo-openebs-default-pool-4bec5da8-qf6z/10.128.0.8
Start Time:   Sun, 03 Dec 2017 14:45:02 +0000
Labels:       name=percona
Annotations:  kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"v1","kind":"Pod","metadata":{"annot
ations":{},"labels":{"name":"percona"},"name":"percona","namespace":"default"},"spec":{"containers":[...
Status:       Running
IP:           10.52.2.5
Containers:
  percona:
    Container ID:  docker://e795eb3efc3d7654af57658e31085825a18de5a2762e697f568fd6ba8f57215e
    Image:         percona
    Image ID:      docker-pullable://percona@sha256:8e74fd9a12f630ebb2ade3fb95db0ad5e353ecf3fdad9689814e4d64e0dc2
e26
    Port:          3306/TCP
    Args:
      --ignore-db-dir
      lost+found
    State:          Running
      Started:      Sun, 03 Dec 2017 14:46:09 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:  500m
    Requests:
      cpu:  500m
    Environment:
--More--

```
