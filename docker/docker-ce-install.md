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
