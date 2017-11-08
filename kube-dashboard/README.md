## Setting up Development Environment for Kubernetes Dashboard using Minikube

### Install Tools
- docker
- go
- npm
- node
- java

Refer: https://github.com/kubernetes/dashboard/wiki/Getting-started


### Clone the dashboard repository. 

To make changes on top of kubernetes/dashboard, it is forked into openebs/dashboard
The changes will be checked into branch: maya-dev

```
cd go/src/github.com/
mkdir kubernetes
cd kubernetes/
git clone https://github.com/openebs/dashboard.git
cd dashboard/
git checkout maya-dev
```

Configure the upstream branch
```
git remote add upstream https://github.com/openebs/openebs.git
git remote set-url --push upstream no_push
git remote -v
```

Rebase with master
```
git fetch upstream master
git rebase upstream/master
git status
git push
```


### Install Dependencies

Refer: https://github.com/kubernetes/dashboard/wiki/Getting-started

```
npm i
```

### Setup minikube and start the kubectl proxy

For installing minikube in Vagrant, 
refer: https://github.com/kmova/bootstrap/tree/master/minikube


### Start the kubectl proxy

```
vagrant@minikube-dev:~$ minikube status
minikube: Running
cluster: Running
kubectl: Correctly Configured: pointing to minikube-vm at 127.0.0.1
vagrant@minikube-dev:~$ kubectl get nodes
NAME           STATUS    ROLES     AGE       VERSION
minikube-dev   Ready     <none>    11h       v1.7.5
vagrant@minikube-dev:~$ kubectl proxy --address="10.0.2.15"
Starting to serve on 10.0.2.15:8001
```
Make sure that dashboard is accessible via http://127.0.0.1:8888/ui

```
export KUBE_DASHBOARD_APISERVER_HOST="http://127.0.0.1:8888"
```

*Note: Specify the --address for kubectl proxy, for cases where port-forward
       is setup using IP address*

### Start heapster for metrics in minikube

```
minikube addons list
sudo minikube addons enable heapster
```

### Build go binary
```
dep ensure -update
```

### Start the Development Dashboard

```
gulp serve
```
