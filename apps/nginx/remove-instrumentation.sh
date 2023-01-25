#!/bin/bash

# Read the domain from CM
#source ../util/loaddomain.sh

kubectl apply -f ingress-nginx-controller-microk8s-no-module.yaml 
