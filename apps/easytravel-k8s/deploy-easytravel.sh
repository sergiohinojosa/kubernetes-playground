#!/bin/bash
 
# Read the domain from CM
source ../util/loaddomain.sh

# Create namespace workshop
kubectl create ns easytravel


# Expose deployment of simplenode
kubectl -n simplenode expose deployment simplenode --type=NodePort --port=8080 --name simplenode

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress-gen.yaml

kubectl -n simplenode apply -f manifests/ingress-gen.yaml

echo "Simplnode is available here:"
kubectl get ing -n simplenode