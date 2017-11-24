
## Setup minikube.
```
sudo -E minikube start --vm-driver=none
```

## Start minikube.
```
sudo minikube start --extra-config=apiserver.Authorization.Mode=RBAC
sudo chown -R $USER $HOME/.kube
sudo chgrp -R $USER $HOME/.kube
sudo chown -R $USER $HOME/.minikube
sudo chgrp -R $USER $HOME/.minikube
```

## Checking Status
```
minikube status
kubectl get pod
```

## Accessing kube-dashboard
```
kubectl proxy --address="10.0.2.15"
```

From the browser access: http://127.0.0.1:8888/ui/

## Starting minikube with custom cluster-ip range
```
minikube start --extra-config=apiserver.ServiceClusterIPRange=40.0.0.0/16
```

## Refer
- https://github.com/kubernetes/minikube
