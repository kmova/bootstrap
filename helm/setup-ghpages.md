Ref: https://gist.github.com/ramnathv/2227408#gistcomment-2915143

```
git clone https://github.com/repo-org/repo-name
cd repo-name
git remote -v
git config -l
git checkout --orphan gh-pages
git status
git rm -rf --dry-run
<remove files that are not required>
git rm -rf
# add _config.yaml, index.md and README.md file
# example: https://github.com/openebs/dynamic-nfs-provisioner/commit/88160042897233181f69eb02611b15631abaf670
git add .
git commit -s -m "chore(gh-pages): setup helm repository"
git push --set-upstream origin gh-pages
```


