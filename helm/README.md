## Pre-requisites
- Have minikube up and running. You can bring up [minikube in a Vagrant VM](../minikube/)
- Ensure that socat is installed. This is used between helm to kubernetes communication. 
  ```
  sudo apt-get install socat
  ```

## Download and install *helm* 

```
curl -Lo /tmp/helm-linux-amd64.tar.gz https://kubernetes-helm.storage.googleapis.com/helm-v2.6.2-linux-amd64.tar.gz
tar -xvf /tmp/helm-linux-amd64.tar.gz -C /tmp/
chmod +x  /tmp/linux-amd64/helm && sudo mv /tmp/linux-amd64/helm /usr/local/bin/
```

## Initialize *helm*
```
helm init
```

## Verify *helm* is installed
```
helm version
kubectl get pods --all-namespaces #should see *tiller* running
```

## Setup RBAC for tiller
```
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
kubectl -n kube-system patch deploy/tiller-deploy -p '{"spec": {"template": {"spec": {"serviceAccountName": "tiller"}}}}'
```

References:
- https://gist.github.com/ssudake21/e60d917ede9c0198f1ae56b07a10dd9a
- https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/
- https://github.com/kubernetes/helm/issues/2224#issuecomment-299939178
