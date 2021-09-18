- Pre-req
  - wipefs
  - partition 

- Install 
  ```
  kubectl apply -f https://openebs.github.io/charts/device-operator.yaml
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
