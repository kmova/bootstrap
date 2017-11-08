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
Latest dashboard (1.7.x)+ is available at http://localhost:8888/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

This may require authentication via kube-token (See https://github.com/kubernetes/dashboard/wiki/Accessing-Dashboard---1.7.X-and-above)

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

### Building local image 
```
export DOCKER_HUB_PREFIX=openebs
gulp docker-image:head
sudo docker images
```

*openebs/kubernetes-dashboard-amd64* should be listed. 

### Upload the image

```
 sudo docker tag ${IMAGE_ID} openebs/kubernetes-dashboard-amd64:${TAG}
 sudo docker tag ${IMAGE_ID} openebs/kubernetes-dashboard-amd64:latest
 sudo docker login -u "${DNAME}" -p "${DPASS}";
 sudo docker push openebs/kubernetes-dashboard-amd64:${TAG}
 sudo docker push openebs/kubernetes-dashboard-amd64:latest
```

### Steps to run in minikube

Stop the default dashboard

```
sudo minikube addons disable dashboard
```

Run the dashboard using the image built above

```
kubectl apply -f https://raw.githubusercontent.com/kmova/bootstrap/master/kube-dashboard/openebs-kubernetes-dashboard.yaml
```
