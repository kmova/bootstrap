# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it include personal hacks
if [ -d "$HOME/go/src/github.com/kmova/bootstrap" ] ; then
    PATH="$HOME/go/src/github.com/kmova/bootstrap/git:$PATH"
    PATH="$HOME/go/src/github.com/kmova/bootstrap/gke-gcloud:$PATH"
    PATH="$HOME/go/src/github.com/kmova/bootstrap/gke-openebs/hack:$PATH"
    PATH="$HOME/go/src/github.com/kmova/bootstrap/openebs-director:$PATH"
else
    echo "personal hacks are not setup"
fi

#setup go 
if [ -d "/usr/local/go_1.13.10/" ] ; then
    export GOPATH="$HOME/go"
    export GOROOT="/usr/local/go_1.13.10/"
    export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
else
    echo "go is not setup"
fi 

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
export KUBECONFIG=$HOME/.kube/config

#gcloud settings
#export PROJECT_ID=
