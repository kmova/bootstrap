Refer:
- https://github.com/kmova/devstats/blob/master/INSTALL_UBUNTU16.md
- https://github.com/golang/go/wiki/Ubuntu



Setup Ubuntu 16.04 on GCP: 

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

10. Install InfluxDB time-series database ([link](https://docs.influxdata.com/influxdb/v0.9/introduction/installation/)):
    - Ubuntu 16 contains very old `influxdb` when installed by default `apt-get install influxdb`, so:
    - `curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -`
    - `source /etc/lsb-release`
    - `echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list`
    - `sudo apt-get update && sudo apt-get install influxdb`
    - `sudo service influxdb start`
    - Create InfluxDB user, database: `IDB_HOST="127.0.0.1" IDB_PASS='your_password_here' ./grafana/influxdb_setup.sh gha`
    - InfluxDB has authentication disabled by default.
    - Edit config file `vim /etc/influxdb/influxdb.conf` and change section `[http]`, `auth-enabled = true` and `[subscriber]` `http-timeout = "300s"`
    - If You want to disable external InfluxDB access (for any external IP, only localhost) follow those instructions [SECURE_INFLUXDB.md](https://github.com/cncf/devstats/blob/master/SECURE_INFLUXDB.md).
    - `sudo service influxdb restart`
    
11. Databases installed, you need to test if all works fine, use database test coverage:
    - `GHA2DB_PROJECT=kubernetes IDB_DB=dbtest IDB_HOST="127.0.0.1" IDB_PASS=your_influx_pwd PG_DB=dbtest PG_PASS=your_postgres_pwd make dbtest`
    - Tests should pass.    
    
 12. We have both databases running and Go tools installed, let's try to sync database dump from k8s.devstats.cncf.io manually:
    - We need to prefix call with GHA2DB_LOCAL to enable using tools from "./" directory
    - You need to have GitHub OAuth token, either put this token in `/etc/github/oauth` file or specify token value via GHA2DB_GITHUB_OAUTH=deadbeef654...10a0 (here You token value)
    - If You really don't want to use GitHub OAuth2 token, specify GHA2DB_GITHUB_OAUTH=- - this will force tokenless operation (via public API), it is a lot more rate limited than OAuth2 which gives 5000 API points/h
    - To import data for the first time (Influx database is empty and postgres database is at the state when Kubernetes SQL dump was made on [k8s.devstats.cncf.io](https://k8s.devstats.cncf.io)):
    - `GHA2DB_GITHUB_OAUTH=- IDB_HOST="127.0.0.1" IDB_PASS=pwd PG_PASS=pwd ./kubernetes/reinit_all.sh`
    - This can take a while (depending how old is psql dump `gha.sql.xz` on [k8s.devstats.cncf.io](https://k8s.devstats.cncf.io). It is generated daily at 3:00 AM UTC.
    - Command should be successfull.
 

Issues:
- Depending on the CPU the initial sync (step#12) can take from 3hrs to 6hrs
- Step #12 to reinit fails with error "Request Entity Too Large".

```
2018-01-25 20:37:58 kubernetes/gha2db_sync: Time: 6h19m30.365479056s
Recreate InfluxDB gha
gha: all OK
Consider fresh restart of `influxd` service, this program temporarily doubles influxd memory usage.
2018-01-25 20:37:59 /idb_backup: idb_backup.go: Running (4 CPUs)
2018-01-25 20:38:19 /idb_backup: Processing 43429 series2018-01-25 20:38:30 /idb_backup: 440/43429 (1.013%), ETA: 2018-01-25 20:54:53.023484123 +0000 UTC m=+1013.776198336
2018-01-25 20:38:40 /idb_backup: Trial #1: error: {"error":"Request Entity Too Large"}

2018-01-25 20:38:40 /idb_backup: Error(time=2018-01-25 20:38:40.612620165 +0000 UTC m=+41.365334366):
{"error":"Request Entity Too Large"}

Stacktrace:
Error(time=2018-01-25 20:38:40.612620165 +0000 UTC m=+41.365334366):
{"error":"Request Entity Too Large"}

Stacktrace:
panic: stacktrace

goroutine 2514 [running]:
devstats.FatalOnError(0x841a00, 0xc42c5aebd0, 0xc421513e58, 0x841a00)
        /home/kiran_mova/data/dev/src/devstats/error.go:24 +0x396
main.copySeries(0xc420d0e5a0, 0xc4200b0580, 0x7ffc1ccbd85f, 0x8, 0x7ffc1ccbd868, 0x3, 0xc4204f5160, 0x1f)
        /home/kiran_mova/data/dev/src/devstats/cmd/idb_backup/idb_backup.go:59 +0xad3
created by main.idbBackup
        /home/kiran_mova/data/dev/src/devstats/cmd/idb_backup/idb_backup.go:117 +0x6cd
root@devstats-devl:/home/kiran_mova/data/dev/src/devstats# 
root@devstats-devl:/home/kiran_mova/data/dev/src/devstats# 
root@devstats-devl:/home/kiran_mova/data/dev/src/devstats# 


---------------

2018-01-26 07:45:40 kubernetes/gha2db_sync: Time: 3h20m2.843259331s
Recreate InfluxDB gha
gha: all OK
Consider fresh restart of `influxd` service, this program temporarily doubles influxd memory usage.
2018-01-26 07:45:40 /idb_backup: idb_backup.go: Running (8 CPUs)
2018-01-26 07:46:00 /idb_backup: Processing 43433 series2018-01-26 07:46:11 /idb_backup: 578/43433 (1.331%), ETA: 2018-01-26 07:59:22.648932474 +0000 UTC m=+821.965447581
2018-01-26 07:46:21 /idb_backup: 1203/43433 (2.770%), ETA: 2018-01-26 07:58:28.914047513 +0000 UTC m=+768.230562620
2018-01-26 07:46:31 /idb_backup: 2123/43433 (4.888%), ETA: 2018-01-26 07:56:29.882116385 +0000 UTC m=+649.198631492
2018-01-26 07:46:41 /idb_backup: 3368/43433 (7.754%), ETA: 2018-01-26 07:54:46.306553441 +0000 UTC m=+545.623068548
2018-01-26 07:46:51 /idb_backup: 4118/43433 (9.481%), ETA: 2018-01-26 07:54:56.364006703 +0000 UTC m=+555.680521810
2018-01-26 07:47:01 /idb_backup: 4952/43433 (11.401%), ETA: 2018-01-26 07:54:53.860509781 +0000 UTC m=+553.177024888
2018-01-26 07:47:11 /idb_backup: 5800/43433 (13.354%), ETA: 2018-01-26 07:54:50.8417256 +0000 UTC m=+550.158240707
2018-01-26 07:47:21 /idb_backup: 6499/43433 (14.963%), ETA: 2018-01-26 07:55:03.728676215 +0000 UTC m=+563.045191322
2018-01-26 07:47:31 /idb_backup: 7457/43433 (17.169%), ETA: 2018-01-26 07:54:52.300749915 +0000 UTC m=+551.617265022
2018-01-26 07:47:41 /idb_backup: 8261/43433 (19.020%), ETA: 2018-01-26 07:54:53.445351209 +0000 UTC m=+552.761866316
2018-01-26 07:47:51 /idb_backup: 9054/43433 (20.846%), ETA: 2018-01-26 07:54:54.867261162 +0000 UTC m=+554.183776269
2018-01-26 07:48:02 /idb_backup: 9623/43433 (22.156%), ETA: 2018-01-26 07:55:08.835418761 +0000 UTC m=+568.151933868
2018-01-26 07:48:13 /idb_backup: 10213/43433 (23.514%), ETA: 2018-01-26 07:55:26.431460554 +0000 UTC m=+585.747975661
2018-01-26 07:48:23 /idb_backup: 11041/43433 (25.421%), ETA: 2018-01-26 07:55:23.96196602 +0000 UTC m=+583.278481127
2018-01-26 07:48:34 /idb_backup: 11829/43433 (27.235%), ETA: 2018-01-26 07:55:24.22157659 +0000 UTC m=+583.538091697
2018-01-26 07:48:44 /idb_backup: 12507/43433 (28.796%), ETA: 2018-01-26 07:55:28.56837162 +0000 UTC m=+587.884886727
2018-01-26 07:48:54 /idb_backup: 13213/43433 (30.422%), ETA: 2018-01-26 07:55:31.467301018 +0000 UTC m=+590.783816125
2018-01-26 07:49:04 /idb_backup: 13810/43433 (31.796%), ETA: 2018-01-26 07:55:38.264073785 +0
2018-01-26 07:47:41 /idb_backup: 8261/43433 (19.020%), ETA: 2018-01-26 07:54:53.445351209 +00
000 UTC m=+597.580588892
2018-01-26 07:49:15 /idb_backup: Trial #1: error: {"error":"Request Entity Too Large"}
2018-01-26 07:49:15 /idb_backup: Error(time=2018-01-26 07:49:15.34052073 +0000 UTC m=+214.657
035825):
{"error":"Request Entity Too Large"}
Stacktrace:
Error(time=2018-01-26 07:49:15.34052073 +0000 UTC m=+214.657035825):
{"error":"Request Entity Too Large"}
Stacktrace:
panic: stacktrace
goroutine 57190 [running]:
devstats.FatalOnError(0x841a00, 0xc42896fc10, 0xc420c57e58, 0x841a00)
        /home/kiran_mova/data/dev/src/devstats/error.go:24 +0x396
main.copySeries(0xc421396240, 0xc4200ba580, 0x7fff798d06cf, 0x8, 0x7fff798d06d8, 0x3, 0xc4205
41240, 0x1f)
        /home/kiran_mova/data/dev/src/devstats/cmd/idb_backup/idb_backup.go:59 +0xad3
created by main.idbBackup
        /home/kiran_mova/data/dev/src/devstats/cmd/idb_backup/idb_backup.go:117 +0x6cd
```
