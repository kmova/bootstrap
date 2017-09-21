
## Starting minikube.

sudo -E minikube start --vm-driver=none
sudo chown -R $USER $HOME/.kube
sudo chgrp -R $USER $HOME/.kube
sudo chown -R $USER $HOME/.minikube
sudo chgrp -R $USER $HOME/.minikube

## Checking Status
minikube status
kubectl get pod

## Refer
- https://github.com/kubernetes/minikube
