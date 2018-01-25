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
    - For example add to `~/.bash_profile` and/or `~/.profile`:
     ```
     GOPATH=$HOME/data/dev; export GOPATH
     PATH=$PATH:$GOPATH/bin; export PATH
     ```
    - Logout and login again.
    - [golint](https://github.com/golang/lint): `go get -u github.com/golang/lint/golint`
    - [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports): `go get golang.org/x/tools/cmd/goimports`
    - [goconst](https://github.com/jgautheron/goconst): `go get github.com/jgautheron/goconst/cmd/goconst`
    - [usedexports](https://github.com/jgautheron/usedexports): `go get github.com/jgautheron/usedexports`
    - [errcheck](https://github.com/kisielk/errcheck): `go get github.com/kisielk/errcheck`
    - Go InfluxDB client: install with: `go get github.com/influxdata/influxdb/client/v2`
    - Go Postgres client: install with: `go get github.com/lib/pq`
    - Go unicode text transform tools: install with: `go get golang.org/x/text/transform` and `go get golang.org/x/text/unicode/norm`
    - Go YAML parser library: install with: `go get gopkg.in/yaml.v2`
    
