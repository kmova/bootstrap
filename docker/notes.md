
## Setup Docker on Mac
https://medium.com/crowdbotics/a-complete-one-by-one-guide-to-install-docker-on-your-mac-os-using-homebrew-e818eb4cfc3

```
$ brew install docker docker-machine
$ brew cask install virtualbox
-> need password
-> possibly need to address System Preference setting
$ docker-machine create --driver virtualbox default
$ docker-machine env default
$ eval "$(docker-machine env default)"
$ docker run hello-world
$ docker-machine stop default
```

## Clear old containers
http://stackoverflow.com/questions/17236796/how-to-remove-old-docker-containers
```
docker rm `docker ps --no-trunc -aq`
```

https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
```
docker system prune -a
```
