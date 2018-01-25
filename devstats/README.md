Refer:
- https://github.com/kmova/devstats/blob/master/INSTALL_UBUNTU16.md
- https://github.com/golang/go/wiki/Ubuntu



Setup Ubuntu 16.06 on GCP: 

Prerequisites:
- Ubuntu 16.04 LTS (on GKE configure with 100GB disk).
- [golang](https://golang.org), this tutorial uses Go 1.9
    - `sudo apt-get update`
    - `sudo apt-get install golang git psmisc jsonlint yamllint gcc`
    - `sudo apt-get install golang-1.9-go`
    - `mkdir $HOME/data; mkdir $HOME/data/dev`
    
1. Configure Go:
    - For example add to `~/.bash_profile` and/or `~/.profile`:
     ```
     PATH="/usr/lib/go-1.9/bin:$PATH"
     GOROOT="/usr/lib/go-1.9"; export GOROOT
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
    - Go GitHub API client: `go get github.com/google/go-github/github`
    - Go OAuth2 client: `go get golang.org/x/oauth2`
    
2. Go to $GOPATH/src/ and clone devstats there:
    - `mkdir github.com/cncf; cd github.com/cncf`
    - `git clone https://github.com/your_github_username/devstats.git`
    - `cd devstats`
    - Set reuse TCP connections (Golang InfluxDB may need this under heavy load): `sudo ./scripts/net_tcp_config.sh`

3. (Merged this into above.)
