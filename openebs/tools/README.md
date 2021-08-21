- Install/upgrade `openebsctl`
  ```
  wget https://raw.githubusercontent.com/openebs/openebsctl/develop/scripts/install-latest.sh -O - | bash
  ```

- Install Dashboard
  ```
  helm repo add openebs-monitoring https://openebs.github.io/monitoring/
  helm repo update
  helm install openebs-dashboard openebs-monitoring/openebs-monitoring --namespace openebs --create-namespace
  ```

  Access at: http://{node-ip}:32515/

  

  
