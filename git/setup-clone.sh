#!/bin/bash -x
if [ "$#" -lt 1 ]; then
    echo "Illegal number of parameters"
    echo "$0 <repo-name> <repo-url> <base-repo-url>"
    exit 1
fi
MYREPO=$1
if [ "$#" -gt 1 ]; then
  MYREPOURL=$2
else
  MYREPOURL="https://github.com/kmova/${MYREPO}"
fi
if [ "$#" -gt 1 ]; then
  ORIGREPOURL=$3
else
  ORIGREPOURL="https://github.com/openebs/${MYREPO}"
fi
git clone $MYREPOURL 
cd $MYREPO && \
 git remote add upstream $ORIGREPOURL && \
 git remote set-url --push upstream no_push && \
 git remote -v 
