#!/bin/bash

# Read the domain from CM
#source ../util/loaddomain.sh

echo "Verifying if you have a Dynakube deployed and the monitoring mode..."

if kubectl get dynakubes.dynatrace.com -n dynatrace -o yaml | grep -q -i 'items: \[\]'; then
    echo "No Dynakubes are configured, exiting and not modifing the configmap of nginx"
else 
    if kubectl get dynakubes.dynatrace.com -n dynatrace -o yaml | grep -q cloudNativeFullStack; then
        echo "CloudNative is active, setting the library for it."
        kubectl apply -f ingress-nginx-controller-microk8s-cn.yaml 
    else   
        echo "ClassicFullStack is active, setting the library for it."
        kubectl apply -f ingress-nginx-controller-microk8s-classic.yaml 
    fi
    echo "Recycling the ingress pod so the library can be mounted."
    kubectl delete pod -n ingress -l name=nginx-ingress-microk8s
fi