#!/bin/bash
 
# Read the domain from CM
source ../util/loaddomain.sh


## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress-gen.yaml

kubectl -n dbic apply -f manifests/

echo "dynabank is available here:"
kubectl get ing -n easytravel
