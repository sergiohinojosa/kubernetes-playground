#!/bin/bash
# Usage: sh deploy-webshell.sh
# Bash for deploying webshell in Kubernetes

#TODO refactor get domain in util function
if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain has been passed: $DOMAIN"
else
    echo "No Domain has been passed, getting it from the ConfigMap"
    DOMAIN=$(kubectl get configmap domain -n default -ojsonpath={.data.domain})
    echo "Domain: $DOMAIN"
fi

#docker run -d --privileged --security-opt seccomp=unconfined --name webshell -p 8018:80 -e ALLOWED_NETWORKS=0.0.0.0/0 bwsw/webshell
kubectl create ns webshell

# Set the public ip for the ingress rule.
sed 's~domain.placeholder~'"$DOMAIN"'~' 03-webshell-ingress.template > gen/03-webshell-ingress.yaml

kubectl -n webshell apply -f .
kubectl -n webshell apply -f gen/
echo "webshell service available at:"
kubectl -n webshell get ing webshell-ingress

