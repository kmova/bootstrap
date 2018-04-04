
[![Go Report](https://goreportcard.com/badge/github.com/kmova/bootstrap)](https://goreportcard.com/report/github.com/kmova/bootstrap) [![codecov](https://codecov.io/gh/kmova/bootstrap/branch/master/graph/badge.svg)](https://codecov.io/gh/kmova/bootstrap) [![GoDoc](https://godoc.org/github.com/kmova/bootstrap/go?status.svg)](https://godoc.org/github.com/kmova/bootstrap/go)


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

## gofmt (format the code with current go version style)

Either pass the new/modified directory (package) or go file before checking it in. 
```
cd $GOPATH/src
gofmt -l github.com/kmova/bootstrap/go/examples/hello
gofmt -w github.com/kmova/bootstrap/go/examples/hello
```

## godoc (Checking on the documentation)
```
cd $GOPATH/src
godoc  cmd/github.com/kmova/bootstrap/go/examples/hello
godoc  cmd/github.com/kmova/bootstrap/go/examples/hello/greetings
```

## goconst (Checking for usage of constants that could be avoided)

Install [goconst](https://github.com/jgautheron/goconst) `go get github.com/jgautheron/goconst/cmd/goconst`

```
cd $GOPATH/src/github.com/kmova/bootstrap/go
goconst -ignore "vendor" -min-occurrences 2 ./... 
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

