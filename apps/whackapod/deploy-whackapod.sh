#!/bin/bash

# Read the domain from CM
source ../util/loaddomain.sh

echo "****  Unfortunately this App is broken .... *****"

echo "**** the moles won't show properly... I think it works on kubernetes 1.16 ****"

kubectl create ns whackapod

sed 's~domain.placeholder~'"$DOMAIN"'~'  manifests/07-ingress.template > manifests/07-ingress-gen.yaml

kubectl -n whackapod apply -f manifests/

kubectl get ing -n whackapod 
