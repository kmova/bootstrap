Provide instructions to have helm installed. 
- sudo minikube start --extra-config=apiserver.Authorization.Mode=RBAC
- wget https://kubernetes-helm.storage.googleapis.com/helm-v2.6.2-linux-amd64.tar.gz
- tar -xvf helm-v2.6.2-linux-amd64.tar.gz
- chmod +x linux-amd64/helm
- sudo mv linux-amd64/helm /usr/local/bin/
- sudo apt-get install socat
Provide instructions to setup helm with minikube
```
vagrant@minikube-dev:~$ helm init
Creating /home/vagrant/.helm 
Creating /home/vagrant/.helm/repository 
Creating /home/vagrant/.helm/repository/cache 
Creating /home/vagrant/.helm/repository/local 
Creating /home/vagrant/.helm/plugins 
Creating /home/vagrant/.helm/starters 
Creating /home/vagrant/.helm/cache/archive 
Creating /home/vagrant/.helm/repository/repositories.yaml 
$HELM_HOME has been configured at /home/vagrant/.helm.

Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster.
Happy Helming!
vagrant@minikube-dev:~$ helm version
Client: &version.Version{SemVer:"v2.6.2", GitCommit:"be3ae4ea91b2960be98c07e8f73754e67e87963c", GitTreeState:"clean"}
Error: cannot connect to Tiller
vagrant@minikube-dev:~$ kubectl get pods
No resources found.
vagrant@minikube-dev:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                              READY     STATUS    RESTARTS   AGE
kube-system   kube-addon-manager-minikube-dev   1/1       Running   0          6m
kube-system   kube-dns-1326421443-cqlgw         3/3       Running   0          3m
kube-system   kubernetes-dashboard-nrqj2        1/1       Running   0          3m
kube-system   tiller-deploy-1936853538-d9rsx    1/1       Running   0          42s
vagrant@minikube-dev:~$ helm version
Client: &version.Version{SemVer:"v2.6.2", GitCommit:"be3ae4ea91b2960be98c07e8f73754e67e87963c", GitTreeState:"clean"}
E1018 08:37:44.822563   15303 portforward.go:331] an error occurred forwarding 43545 -> 44134: error forwarding port 44134 to pod 92ddfe7c95db42998c6bf5612c5e5cb925577626647352c8d8d5b00ed68e83f9, uid : unable to do port forwarding: socat not found.
Error: cannot connect to Tiller
vagrant@minikube-dev:~$ helm version
Client: &version.Version{SemVer:"v2.6.2", GitCommit:"be3ae4ea91b2960be98c07e8f73754e67e87963c", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.6.2", GitCommit:"be3ae4ea91b2960be98c07e8f73754e67e87963c", GitTreeState:"clean"}
vagrant@minikube-dev:~$ 
vagrant@minikube-dev:~$ minikube version
minikube version: v0.22.3
vagrant@minikube-dev:~$ kubectl version
Client Version: version.Info{Major:"1", Minor:"8", GitVersion:"v1.8.1", GitCommit:"f38e43b221d08850172a9a4ea785a86a3ffa3b3a", GitTreeState:"clean", BuildDate:"2017-10-11T23:27:35Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"7", GitVersion:"v1.7.5", GitCommit:"17d7182a7ccbb167074be7a87f0a68bd00d58d97", GitTreeState:"clean", BuildDate:"2017-10-06T20:53:14Z", GoVersion:"go1.8.3", Compiler:"gc", Platform:"linux/amd64"}
vagrant@minikube-dev:~$ 
vagrant@minikube-dev:~$ 
vagrant@minikube-dev:~$ 
vagrant@minikube-dev:~$ helm ls
vagrant@minikube-dev:~$ helm repo update 
Hang tight while we grab the latest from your chart repositories...
...Skip local chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈ Happy Helming!⎈ 
vagrant@minikube-dev:~$ helm ls
vagrant@minikube-dev:~$ 

  121  kubectl -n kube-system create sa tiller
  122  kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
  123  kubectl -n kube-system patch deploy/tiller-deploy -p '{"spec": {"template": {"spec": {"serviceAccountName": "tiller"}}}}'


```
Provide instructions to run openebs from github location
```
  142  helm install --name openebs .
  143  kubectl get pods
  144  kubectl describe pod maya-apiserver-927297988-jx2q0
  145  kubectl get pods
  146  history
vagrant@minikube-dev:/vagrant/helm/charts/openebs$ pwd
/vagrant/helm/charts/openebs
vagrant@minikube-dev:/vagrant/helm/charts/openebs$ 

```

Clearing or deleting openebs via helm
```
vagrant@minikube-dev:/vagrant/helm/charts/openebs$ helm ls --all
NAME   	REVISION	UPDATED                 	STATUS	CHART        	NAMESPACE
openebs	1       	Wed Oct 18 12:17:10 2017	FAILED	openebs-0.0.1	default  
vagrant@minikube-dev:/vagrant/helm/charts/openebs$ helm del --purge openebs
release "openebs" deleted
vagrant@minikube-dev:/vagrant/helm/charts/openebs$ 
```

References:
- https://gist.github.com/ssudake21/e60d917ede9c0198f1ae56b07a10dd9a
- https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/
- https://github.com/kubernetes/helm/issues/2224#issuecomment-299939178
