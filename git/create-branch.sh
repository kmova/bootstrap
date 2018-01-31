#!/bin/bash -x
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "$0 <branch-name>"
    exit 1
fi
MYBRANCH=$1
git branch $MYBRANCH
git checkout $MYBRANCH
git push --set-upstream origin $MYBRANCH
