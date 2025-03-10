#!/bin/bash

kubectl create ns todoapp

# Create deployment of tictactoe
kubectl -n todoapp create deploy todoapp --image=shinojosa/todoapp:1.0.0

# Expose deployment of tictactoe with a Service
kubectl -n todoapp expose deployment todoapp --type=NodePort --port=8080 --name todoapp

# Expose the Service with an Ingress and a magic domain
## Get Public IP as NIP Domain
export PUBLIC_IP=$(curl -s ifconfig.me) 
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress.yaml

kubectl -n todoapp apply -f manifests/ingress.yaml

echo "Todo App is available at.."
kubectl get ing -n todoapp