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


## go get

Let us say we want to run the hello world example from this repository. Go will automatically checkout the directory for you from Github (or any other respository) and compile the package. 
```
go get github.com/kmova/bootstrap/go/examples/hello
hello
```

## go test (unit tests)

Let us say we want to run the unit tests for hello world example from this repository. 
```
go test github.com/kmova/bootstrap/go/examples/hello
```


## go test (benchmark tests)

Let us say we want to run the unit tests for hello world example from this repository. 
```
go test -bench=. github.com/kmova/bootstrap/go/examples/hello
```

## go test (coverage analysis)

Get the test coverage details per function 

```
go test -coverprofile=/tmp/hellocover.out github.com/kmova/bootstrap/go/examples/hello
go tool cover -func=/tmp/hellocover.out
```

## go run 

Use this mechanism when you want to run a specific go file from a respository. We sill run the same hello world program using go run. 

```
cd $GOPATH/src
mkdir -p $GOPATH/src/github.com/kmova
cd $GOPATH/src/github.com/kmova
git clone https://github.com/kmova/bootstrap.git
go run bootstrap/go/examples/hello/main.go
```

