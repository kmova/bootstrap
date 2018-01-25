Refer:
- https://github.com/kmova/devstats/blob/master/INSTALL_UBUNTU16.md


Setup Ubuntu 16.06 on GCP: 

Prerequisites:
- Ubuntu 16.04 LTS (on GKE configure with 100GB disk).
- [golang](https://golang.org), this tutorial uses Go 1.6
    - `apt-get update`
    - `apt-get install golang git psmisc jsonlint yamllint gcc`
    - `mkdir $HOME/data; mkdir $HOME/data/dev`
    
1. Configure Go:
    - For example add to `~/.profile`:
     ```
     GOPATH=$HOME/data/dev;
     PATH=$PATH:$GOPATH/bin;
     ```
    - Logout and login again.
    
