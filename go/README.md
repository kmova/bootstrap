# Setup Go 

You can follow the instructions [here](https://golang.org/doc/install) to install go on your machine. 
Or you can use the below instructions to setup Go development Environment using Vagrant and VirtualBox on Ubuntu. 

## Setup Go using vagrant and virtualbox.

```
cd <work-dir>
git clone https://github.com/kmova/bootstrap.git
cd <work-dir>/bootstrap/go
vagrant up
```

## Setting your Go env. 

Your **env** should have the following variables set: 
GOROOT - pointing to the golang installed directory ( say /usr/local/go )
GOPATH - directory where the go source code will be localed. This directory will need to have *src, pkg, bin* as subfolders.
GOBIN  - an optional variable that tells where the compilied go binaries are kept. 

Make sure $GOROOT and $GOBIN are also added to your $PATH. 

Verify go is installed by running *go version*

## Running the Go examples from this repository

```
cd $GOPATH/src
mkdir -p $GOPATH/src/github.com/kmova
cd $GOPATH/src/github.com/kmova
git clone https://github.com/kmova/bootstrap.git
go run bootstrap/go/examples/hello/main.go
```

