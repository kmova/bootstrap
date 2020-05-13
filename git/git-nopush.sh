#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Specify repo url to download"
    echo "$0  <repo-url> "
    exit 1
fi

MYREPOURL=$1
MYREPO=$(echo $1 | rev | cut -d '/' -f1 | rev | cut -d '.' -f1)

echo "Cloning $MYREPOURL into $MYREPO"

if [[ -d $MYREPO ]]; then 
  cd $MYREPO && git pull && cd ..
else 
  git clone $MYREPOURL 
fi 

cd $MYREPO && \
 git remote set-url --push origin no_push && \
 git remote -v 
