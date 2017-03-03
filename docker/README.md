
Building Docker Images

```
cd <dockerbuilddir>
docker build -t <image-name> .
```

Push Docker Images
```
docker images
docker tag <image-id> <dockerhubaccount>/<image-name>:<tag-name>
docker login
docker push <dockerhubaccount>/<image-name>:<tag-name>
```



