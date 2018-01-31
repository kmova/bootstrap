#!/bin/bash -x
if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters"
    echo "$0 <repo-name> <repo-url> <base-repo-url>"
    exit 1
fi
MYREPO=$1
MYREPOURL=$2
ORIGREPOURL=$3
git clone $MYREPOURL 
cd $MYREPO && \
 git remote add upstream $ORIGREPOURL && \
 git remote set-url --push upstream no_push && \
 git remote -v 
