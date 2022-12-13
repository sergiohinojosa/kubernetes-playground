#!/bin/bash
# Usage: sh deploy-etherpad.sh
# Bash for deploying etherpad in Kubernetes
# Application https://github.com/ether/etherpad-lite/blob/develop/doc/docker.md

# Read the domain from CM
source ../util/loaddomain.sh

kubectl create ns etherpad

sed 's~domain.placeholder~'"$DOMAIN"'~' 03-etherpad-ingress.template > 03-etherpad-ingress-gen.yaml

kubectl -n etherpad apply -f .

echo "Etherpad service available at:"
kubectl -n etherpad get ing 