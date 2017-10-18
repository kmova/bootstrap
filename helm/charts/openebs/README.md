
# Prerequisites
- Kubernetes 1.7.5+ with RBAC enabled
- iSCSI PV support in the underlying infrastructure


# Installing OpenEBS from Chart codebase
```
git clone https://github.com/kmova/bootstrap.git
cd bootstrap/helm/charts/openebs/
helm install --name openebs .
```

# Unistalling OpenEBS from Chart codebase
```
helm ls --all
helm del --purge openebs
```
