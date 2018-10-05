
if [ "$#" -gt 0 ]; then
  BRANCH=$1
else
  echo "specify the orig branch to be synced"
fi

git fetch upstream ${BRANCH}:${BRANCH}
git checkout ${BRANCH}
git push --set-upstream origin ${BRANCH}

