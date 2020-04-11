# set PATH so it includes private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
PATH="$HOME/go/src/github.com/kmova/bootstrap/git:$PATH"
PATH="$HOME/go/src/github.com/kmova/bootstrap/gke-gcloud:$PATH"
PATH="$HOME/go/src/github.com/kmova/bootstrap/gke-openebs/hack:$PATH"
PATH="$HOME/go/src/github.com/kmova/bootstrap/openebs-director:$PATH"

#setup go 
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go_1.13.10/"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

#env variables for running git cli commands
#export GIT_NAME=
#export GIT_TOKEN=

#env variables for running openebs director cli commands
#export DIRECTOR_GROUP_ID=
#export DIRECTOR_PKEY=
#export DIRECTOR_PROJ_ID=
#export DIRECTOR_PROJ_NAME=
#export DIRECTOR_SKEY=
#export DIRECTOR_URL=

#env variables for docker cli
#export DNAME=
#export DPASS=

#env variables for kubectl
#export KUBECONFIG=$HOME/.kube/config

#gcloud settings
#export PROJECT_ID=
