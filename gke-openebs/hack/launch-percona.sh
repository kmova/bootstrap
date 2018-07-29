kubectl create namespace percona-test 
kubectl apply -f https://raw.githubusercontent.com/kmova/bootstrap/master/gke-openebs/demo-percona/percona-openebs-deployment.yaml

#JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; 
JSONPATH='{range .items[0]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; 
until kubectl get pods -n percona-test -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True";
do
  echo -n "."
  sleep 2; 
done
echo ""
kubectl get pods -n percona-test
