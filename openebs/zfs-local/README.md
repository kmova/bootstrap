- Pre-req
  - wipefs
  - zpool creation

- Install 
  ```
  helm upgrade openebs openebs/openebs --namespace openebs --reuse-values --set zfs-localpv.enabled=true
  ```

  ```
  kubectl apply -f https://openebs.github.io/charts/zfs-operator.yaml
  ```
- Configuration 
  - Apply SC
  - Check Pool Status
    ```
    kubectl openebs get storage
    ```
- Application
  - Update SC
  - Launch App 
  - Check Volume Status
    ```
    kubectl openebs get storage
    ```
