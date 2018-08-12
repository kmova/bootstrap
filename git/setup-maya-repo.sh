#!/bin/bash -x

if [ -z $GOPATH ]; then
    echo "GOPATH is not set"
    exit 1
fi

mkdir -p $GOPATH/src/github.com/openebs

cd $GOPATH/src/github.com/openebs && \
 git clone https://github.com/kmova/maya.git

cd $GOPATH/src/github.com/openebs/maya && \
 git remote add upstream https://github.com/openebs/maya.git && \
 git remote set-url --push upstream no_push && \
 git remote -v 
