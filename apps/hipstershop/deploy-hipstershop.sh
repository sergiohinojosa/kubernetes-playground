#!/bin/bash

# Read the domain from CM
source ../util/loaddomain.sh

sed 's~domain.placeholder~'"$DOMAIN"'~'  ingress.template > manifests/ingress-gen.yaml

kubectl create ns hipstershop
kubectl -n hipstershop apply -f manifests/

echo "The application is available in the following endpoints"
kubectl get ing -n hipstershop
