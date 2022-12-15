#!/bin/bash +x
# Set up of the Book application of istio for Microk8s
# https://istio.io/docs/examples/bookinfo/
 
# Read the domain from CM
source ../util/loaddomain.sh

echo "We create a bookinfo namespace for the application"
kubectl create ns bookinfo

echo "enable the isito injection in the bookinfo namespace"
kubectl label namespace bookinfo istio-injection=enabled

echo "Create Ingress Rule"
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress-gen.yaml

echo "deploy the bookinfo app"
kubectl -n bookinfo apply -f manifests/ 

BOOKDOMAIN=$(kubectl get ing -n bookinfo -o=jsonpath={.items[0].spec.rules[0].host})

printf "\n\n*****\nThe Book application is now available at http://$BOOKDOMAIN/productpage\n*******\n\n"
