## Clear old containers
http://stackoverflow.com/questions/17236796/how-to-remove-old-docker-containers
```
docker rm `docker ps --no-trunc -aq`
```

https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
```
docker system prune -a
```
