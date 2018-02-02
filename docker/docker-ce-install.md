https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1


7  sudo apt-get update
    8  sudo apt-get install apt-transport-https ca-certificates software-properties-common
    9  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   10  sudo apt-key fingerprint 0EBFCD88
   11  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(l
sb_release -cs) stable"
   12  sudo apt-get update
   13  sudo apt-get install docker-ce
   14  sudo docker run hello-world
   15  history
   
https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-snap-on-ubuntu

    1  sudo snap install kubectl --classic
    2  kubectl versino
    3  kubectl version
    4  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-lin
ux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
    5  minikube

  17  mkdir $HOME/.kube || true
   18  touch $HOME/.kube/config
   19  vi ~/.profile
   
   
   export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=$HOME/.kube/config

   
      20  source ~/.profile
      22  sudo -E minikube start --vm-driver=none
   23  sudo docker images
   24  kubectl get pods
   25  kubectl get pods --all-namespaces
   
  
  
  
  
  
   ```
   ExecStart=/usr/local/bin/localkube   --dns-domain=cluster.local --node-ip=10.128.0.12 --generate-certs=false --logtostderr=true --enable-dns=false --apiserver-insecure-address=0.0.0.0 --apiserver-insecure-port=8080 --apiserver-port=0 --extra-config=controller-manager.master=http://10.128.0.12:8080/ --generate-kubeconfig=true
   ```
   
  - building localkube https://github.com/kubernetes/minikube/blob/master/docs/contributors/releasing_localkube.md 
   
   ```
   kiran_mova@kmova-minikube:~/go/src/k8s.io/minikube$ git diff 
diff --git a/pkg/localkube/apiserver.go b/pkg/localkube/apiserver.go
index 5ea4d49..dd995c2 100644
--- a/pkg/localkube/apiserver.go
+++ b/pkg/localkube/apiserver.go
@@ -100,5 +100,5 @@ func StartAPIServer(lk LocalkubeServer) func() error {
 
 func readyFunc(lk LocalkubeServer) HealthCheck {
        return healthCheck(lk.GetAPIServerProtocol()+path.Join(
-               net.JoinHostPort("localhost", strconv.Itoa(lk.APIServerPort)), "healthz"), lk)
+               net.JoinHostPort("localhost", strconv.Itoa(lk.GetAPIServerPort())), "healthz"), lk)
 }
diff --git a/pkg/localkube/localkube.go b/pkg/localkube/localkube.go
index 3b08b90..6f855cf 100644
--- a/pkg/localkube/localkube.go
+++ b/pkg/localkube/localkube.go
@@ -128,6 +128,13 @@ func (lk LocalkubeServer) GetAPIServerProtocol() string {
        return "https://"
 }
 
+func (lk LocalkubeServer) GetAPIServerPort() int {
+       if lk.APIServerInsecurePort != 0 {
+               return lk.APIServerInsecurePort
+       }
+       return lk.APIServerPort
+}
+
 func (lk LocalkubeServer) GetTransport() (*http.Transport, error) {
        if lk.APIServerInsecurePort != 0 {
                return &http.Transport{}, nil
kiran_mova@kmova-minikube:~/go/src/k8s.io/minikube$ 
```
