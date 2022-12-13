#!/bin/bash
source ./utils.sh

deploy_operator() {
    export DT_API_TOKEN=$DT_API_TOKEN
    export DT_INGEST_TOKEN=$DT_INGEST_TOKEN
    export DT_API_URL=$DT_TENANT/api

    # Install the operator
    echo "Installing the Dynatrace Operator, ActiveGate, Webhook and CSI-driver"

    kubectl create namespace dynatrace
 
    kubectl apply -f https://github.com/Dynatrace/dynatrace-operator/releases/download/v0.10.0/kubernetes.yaml

    # Download the CSI Driver impl 
    curl -o gen/csi.yaml -L https://github.com/Dynatrace/dynatrace-operator/releases/download/v0.10.0/kubernetes-csi.yaml
    # Changing the destination of the kubelet for Microk8s to deploy the CSI driver succesfully
    sed -e 's~/var/lib/kubelet/~/var/snap/microk8s/common/var/lib/kubelet/~' gen/csi.yaml > gen/microk8s-csi.yaml

    # Save Dynatrace Secret 
    kubectl -n dynatrace create secret generic k8s-playground --from-literal="apiToken=$DT_API_TOKEN" --from-literal="dataIngestToken=$DT_INGEST_TOKEN" 

    # Replace URL and name for CloudNative and Classic FS Deployment
    sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~' dynakube-classic.yaml > gen/dynakube-classic.yaml

    sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~' dynakube-cloudnative.yaml > gen/dynakube-cloudnative.yaml
}



echo "Deploying the Dynatrace Operator..."
readCredsFromFile
printVariables
echo "Are the values correct? Continue? [y/n]"
read REPLY
case "$REPLY" in
[yY])
    deploy_operator
    ;;
*)
    echo "Ok then run ./save-credentials.sh to set the new credentials"
    exit
    ;;
esac
exit
