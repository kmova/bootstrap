#!/bin/bash -x
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "$0 <branch-name>"
    exit 1
fi
MYBRANCH=$1
git branch -d $MYBRANCH
git push origin --delete $MYBRANCH
