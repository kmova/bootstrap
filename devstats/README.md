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
    - `git clone https://github.com/your_github_username/devstats.git`
    - `cd devstats`
    - Set reuse TCP connections (Golang InfluxDB may need this under heavy load): `sudo ./scripts/net_tcp_config.sh`

3. (Merged this into above.)

4. Go to devstats directory, so you are in `$GOPATH/src/devstats` directory and compile binaries:
    - `make`
    
5. If compiled sucessfully then execute test coverage that doesn't need databases:
    - `make test`
    - Tests should pass.
6. Install binaries & metrics:
    - `sudo mkdir -p /etc/gha2db/metrics/`
    - `sudo chmod 777 /etc/gha2db`
    - `sudo make install`    

7. Install Postgres database ([link](https://gist.github.com/sgnl/609557ebacd3378f3b72)):
    - apt-get install postgresql 
    - sudo -i -u postgres
    - psql
    - Postgres only allows local connections by default so it is secure, we don't need to disable external connections:
    - Instructions to enable external connections (not recommended): `http://www.thegeekstuff.com/2014/02/enable-remote-postgresql-connection/?utm_source=tuicool`
    
8. Inside psql client shell:
    - `create database gha;`
    - `create database devstats;`
    - `create user gha_admin with password 'your_password_here';`
    - `grant all privileges on database "gha" to gha_admin;`
    - `grant all privileges on database "devstats" to gha_admin;`
    - `alter user gha_admin createdb;`
    - Leave the shell and create logs table for devstats: `sudo -u postgres psql devstats < util_sql/devstats_log_table.sql`.

9. Leave `psql` shell, and get newest Kubernetes database dump:
    - `wget https://devstats.cncf.io/gha.sql.xz` (it is about 400Mb).
    - `xz -d gha.sql.xz` (uncompressed dump is more than 7Gb).
    - `sudo -u postgres psql gha < gha.sql` (restore DB dump)
