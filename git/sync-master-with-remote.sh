
BRANCH="master"
if [ "$#" -gt 0 ]; then
  BRANCH=$1
fi

git checkout ${BRANCH}
git fetch upstream ${BRANCH}
git rebase upstream/${BRANCH}
git status
git push origin ${BRANCH}
