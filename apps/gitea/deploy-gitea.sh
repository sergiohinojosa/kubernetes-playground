#!/bin/bash

# Load git vars
source ./gitea-vars.sh

echo "create namespace for gitea"
kubectl create ns gitea

sed -e 's~domain.placeholder~'"$DOMAIN"'~' \
    -e 's~GIT_USER.placeholder~'"$GIT_USER"'~' \
    -e 's~GIT_PASSWORD.placeholder~'"$GIT_PASSWORD"'~' \
    helm-gitea.yaml > gen/helm-gitea.yaml

echo "install gitea via Helmchart"
helm install gitea gitea-charts/gitea -f gen/helm-gitea.yaml --namespace gitea

echo "gitea is available at"
kubectl get ing -n gitea 