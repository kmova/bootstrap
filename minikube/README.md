## Installing minikube.

Install VirtualBox

```
sudo apt-get install virtualbox
```
Install kubectl 
```
sudo snap install kubectl --classic
```
Install minikube
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.22.3/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```

## Running Kubernetes Cluster Locally via Minikube

Start minkube 
```
minikube start
```

## Clone Kubernetes dashboard and install the dependencies

Make sure the following software is installed

* Docker 1.10+ (https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
* Golang 1.8+ (https://golang.org/dl/)
* Node.js 8+ and npm 5+ (https://github.com/creationix/nvm#usage)
* Java 7+ (http://openjdk.java.net/install/)
* Gulp.js 3.9+ (https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md#install-the-gulp-command)

Clone kubernetes dashboard 
```
git clone https://github.com/kubernetes/dashboard.git
```
Install the dependencies 
```
cd dashboard
npm i
```
## Run Kubernetes dashboard with minikube

Create kubernetes proxy
```
kubectl proxy --port=8080
```
Open a new terminal and cd to kubernetes dashboard directory and run following command
```
gulp serve
```
Open a browser and access the UI under http://localhost:9090

## Setting up OpenEBS in Kubernetes

Set up Open-iSCSI 
```
sudo apt-get update
sudo apt-get install open-iscsi
```
Perform this procedure to run OpenEBS operator 
```
kubectl create/apply -f https://github.com/openebs/openebs/blob/master/k8s/openebs-operator.yaml
kubectl create/apply -f https://github.com/openebs/openebs/blob/master/k8s/openebs-storageclasses.yaml
```
Now you should be able to see OpenEBS Pods under http://localhost:9090/#!/pod?namespace=default
and Storage Classes under http://localhost:9090/#!/storageclass?namespace=default

## Refer
- https://github.com/kubernetes/minikube
