#!/bin/bash
 
# Read the domain from CM
source ../util/loaddomain.sh
kubectl create namespace easytrade

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress-gen.yaml

kubectl -n dbic apply -f manifests/

echo "easytrade is available here:"
kubectl get ing -n easytrade
