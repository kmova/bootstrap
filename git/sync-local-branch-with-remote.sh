#!/bin/bash -x
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "$0 <branch-name>"
    exit 1
fi
MYBRANCH=$1
git checkout $MYBRANCH
git fetch upstream $MYBRANCH
git rebase upstream/$MYBRANCH
git status
#git push origin master
