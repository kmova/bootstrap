# Setup Go 

You can follow the instructions [here](https://golang.org/doc/install) to install go on your machine. 
Or you can use this [vagrant file](https://raw.githubusercontent.com/kmova/bootstrap/master/go/Vagrantfile) to create an ubuntu VM with Go.

## Setup Go using vagrant and virtualbox.

```
cd <work-dir>
git clone https://github.com/kmova/bootstrap.git
cd <work-dir>/bootstrap/go
vagrant up
```

## Check your Go installation

The paths shown can be different, depending on where you installed go (GOROOT) and go source directory (GOPATH). 

```
vagrant@go-dev:~$ go version
go version go1.8 linux/amd64
vagrant@go-dev:~$ echo $GOPATH
/home/vagrant/go
vagrant@go-dev:~$ echo $GOBIN 
/home/vagrant/go/bin
vagrant@go-dev:~$ echo $GOROOT
/usr/local/go
vagrant@go-dev:~$             
```

## Running the Go examples in this repository

Create the go source and build directories.
```
vagrant@go-dev:~/go$ mkdir -p $GOPATH/src
vagrant@go-dev:~/go$ mkdir -p $GOPATH/bin
vagrant@go-dev:~/go$ mkdir -p $GOPATH/pkg
```

Clone your repository and run the code. 

```
vagrant@go-dev:~/go$ cd $GOPATH/src
vagrant@go-dev:~/go/src$ mkdir -p $GOPATH/src/github.com/kmova
vagrant@go-dev:~/go/src$ cd $GOPATH/src/github.com/kmova
vagrant@go-dev:~/go/src/github.com/kmova$ git clone https://github.com/kmova/bootstrap.git
Cloning into 'bootstrap'...
remote: Counting objects: 141, done.
remote: Compressing objects: 100% (67/67), done.
remote: Total 141 (delta 27), reused 0 (delta 0), pack-reused 69
Receiving objects: 100% (141/141), 580.29 KiB | 383.00 KiB/s, done.
Resolving deltas: 100% (45/45), done.
Checking connectivity... done.
vagrant@go-dev:~/go/src/github.com/kmova$ go run bootstrap/go/examples/hello/
greetings/ main.go    README.md  
vagrant@go-dev:~/go/src/github.com/kmova$ go run bootstrap/go/examples/hello/main.go 
Hello, world.
Hello, I am from your first go package!
vagrant@go-dev:~/go/src/github.com/kmova$ 
```

Customize git for code checkin

```
git config --global user.name "kmova"
```

