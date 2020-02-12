# Installing GitLab on GKE with OpenEBS

## Prerequisites

- Create a domain name and static IP address and setup the DNS entries
  - Create static ip address in the region where GitLab will be deployed.
    Note the PROJECT ID using `gcloud info` 
    ```
    gcloud compute addresses create gitlab-demo-external-ip --region us-central1 --project $PROJECT
    gcloud compute addresses describe gitlab-demo-external-ip --region us-central1 --project $PROJECT --format='value(address)'
    ```
  - Setup the DNS entry for Static IP with domain name. 
    Assuming `mayaonline.io` is the domain name, 
    setup `A record` for gitlab.mayaonline.io with the DNS registrar.

- Customize the gke_bootstrap.sh script. (This script was downloaded from gitlab docs and
  customized to be used with OpenEBS).
  - Modify the following in the scripts: 
    - set the cluster name. Note that the name and external-ip(above) have to match.
    - update the cluster create command as you see fit. 

- Make sure you have admin access to create GKE cluster and your helm version 
  is above 2.12

## Create GKE Cluster
- Create GKE cluster using bootstrap scripts
  ```
  export PROJECT=strong-eon-xxxxx
  ./gke_bootstrap.sh up
  ```

  Cluster will be setup using RBAC and helm will be installed. 

## Install and configure OpenEBS

  ```
  helm install --namespace openebs --name openebs stable/openebs
  kubectl get pods -n openebs
  kubectl get bd -n openebs -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeAttributes.nodeName,PATH:spec.path,FS:spec.filesystem.mountPoint

  #Edit spc-cstor-multizone.yaml
  kubectl apply -f spc-cstor-multizone.yaml
  kubectl apply -f sc-openebs-localssd.yaml
  ```

## Install GitLab

- update the values-openebs-gke.yaml with appropriate storage class values. 

- Run the gitlab helm chart
  ```
  helm repo add gitlab-openebs https://charts.gitlab.io/
  helm repo update
  helm search -l gitlab-openebs/gitlab
  helm upgrade --install gitlab gitlab-openebs/gitlab -f values-openebs-gke.yaml --timeout 600
  ```

## Verify

- Wait for all the pods, certificates and svc to be online. 
  ```
  kubectl get -n gitlab pods
  kubectl get -n gitlab svc
  kubectl get -n gitlab certificates
  kubectl get pvc -n gitlab
  ```

- Get `root` user auto-generated password
  ```
  kubectl get -n gitlab secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo
  ```

- Login to https://gitlab.mayaonline.io
  You can register as a new user and login as well. 

## References

- https://docs.gitlab.com/charts/installation/cloud/gke.html
- https://gitlab.com/gitlab-org/charts/gitlab/blob/master/scripts/gke_bootstrap_script.sh
- https://gitlab.com/gitlab-org/charts/gitlab/-/blob/master/scripts/common.sh

