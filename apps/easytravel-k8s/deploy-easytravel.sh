#!/bin/bash
 
# Read the domain from CM
source ../util/loaddomain.sh

# Create namespace workshop
kubectl create ns easytravel

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress-gen.yaml

kubectl -n easytravel apply -f manifests/

echo "Easytravel is available here:"
kubectl get ing -n easytravel