- Pre-req
  - wipefs
  - vg creation

- Install 
  ```
  helm upgrade openebs openebs/openebs --namespace openebs --reuse-values --set lvm-localpv.enabled=true
  ```

  ```
  kubectl apply -f https://openebs.github.io/charts/lvm-operator.yaml
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
