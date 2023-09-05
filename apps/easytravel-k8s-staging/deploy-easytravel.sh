#!/bin/bash
 
# Read the domain from CM
source ../util/loaddomain.sh

# Create namespace workshop
kubectl create ns staging-easytravel

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress-gen.yaml

kubectl -n staging-easytravel apply -f manifests/

echo "Easytravel is available here:"
kubectl get ing -n staging-easytravel