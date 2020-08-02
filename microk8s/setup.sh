#ref: https://microk8s.io/
sudo snap install microk8s --classic
microk8s status --wait-ready
microk8s enable host-access storage rbac
microk8s inspect
microk8s config > ~/.kube/config
