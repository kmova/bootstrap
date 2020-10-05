Create NFS server 
```
kubectl create namespace nfs-app-1
kubectl apply -n nfs-app-1 -f nfs-server.yaml 
```

Create NFS PV and PVC
```
kubectl apply -f nfs-app-1-pv-setup.yaml 
```

Use the NFS PVC and launch an application with multiple replicas. 
```
kubectl apply -n nfs-app-1 -f nfs-busybox-rc.yaml 
```

Verify that data is being written from multiple pods to same file. 
```
kubectl exec -it -n nfs-app-1 <nfs-busybox pod name> -- cat /mnt/index.html
```


Setup another NFS server for another application. 
```
kubectl create namespace nfs-app-2
kubectl apply -n nfs-app-2 -f nfs-server.yaml 
kubectl apply -f nfs-app-2-pv-setup.yaml
kubectl apply -n nfs-app-2 -f nfs-busybox-rc.yaml
```

Credit:
* https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs
* https://timberry.dev/posts/shared-storage-gke-regional-pds-nfs/
* https://github.com/sjiveson/nfs-server-alpine

