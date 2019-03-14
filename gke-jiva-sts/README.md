Notes

- Requires K8s 1.12 and higher. 

- Install OpenEBS with hostpath PV provisioner
  ```
  kubectl apply -f openebs-operator-0.8.2-ci.yaml 
  kubectl apply -f local-path-storage.yaml
  ```

- Update CAS templates for creating Jiva Replicas using STS
  ```
  kubectl apply -f jiva-volume-create-putreplicasts-default-0.8.1.yaml
  kubectl apply -f jiva-volume-create-sts-0.8.1.yaml
  kubectl apply -f sc-jiva-sts.yaml
  ```

- Test new new jiva replica
  ```
  kubectl apply -f pvc-jiva-sts.yaml 
  kubectl exec -it busybox /bin/sh
  ```
