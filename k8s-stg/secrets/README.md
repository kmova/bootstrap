
Examples:

(a) secret-permissions.yaml - pods to demonstrate different defaultModes

    Check the permission of the files username and password in the kubectl logs of each pod. 

    Usage:
      kubectl apply -f secret-permissions.yaml 
      kubectl logs secret-pod
      kubectl logs secret-pod-256
      kubectl logs secret-pod-511


