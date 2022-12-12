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

    curl -o gen/csi.yaml -L https://github.com/Dynatrace/dynatrace-operator/releases/download/v0.10.0/kubernetes-csi.yaml
    
    # Changing the destination of the kubelet for Microk8s to deploy the CSI driver succesfully
    sed -e 's~/var/lib/kubelet/~/var/snap/microk8s/common/var/lib/kubelet/~' gen/csi.yaml > gen/microk8s-csi.yaml

    # Save Secret
    kubectl -n dynatrace create secret generic k8s-playground --from-literal="apiToken=$DT_API_TOKEN" --from-literal="dataIngestToken=$DT_INGEST_TOKEN" 

    #Cloud Native FS
    curl -o gen/cloudNativeFullStack.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-operator/release-0.10/assets/samples/cloudNativeFullStack.yaml

    # Replace URL and name
    sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~' dynakube-classic.yaml > gen/dynakube-classic.yaml

    sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~' dynakube-cloudnative.yaml > gen/dynakube-cloudnative.yaml

    kubectl -n dynatrace apply -f gen/dynakube-classic.yaml

    echo "Dynatrace Operator with Classic Fullstack monitoring mode will be deployed. "

    # kubectl -n dynatrace delete dynakube-f 
    #kubectl apply -f gen/csi-microk8s.yaml

}




deploy_Dynakube(){
    # Download dynakube
     curl -o gen/cloudNativeFullStack.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-operator/release-0.10/assets/samples/cloudNativeFullStack.yaml
    # Replace the variables and save as different yaml

    # Save secret
    sed -e 's~apiUrl:~apiUrl:'"$DT_API_URL"'~' \
    -e 's~KEPTN_API_TOKEN.placeholder~'"$KEPTN_API_TOKEN"'~' \
    -e 's~KEPTN_ENDPOINT.placeholder~'"$KEPTN_ENDPOINT"'~' \
    -e 's~KEPTN_BRIDGE.placeholder~'"$KEPTN_BRIDGE"'~' \
    -e 's~DT_TENANT.placeholder~'"$DT_TENANT"'~' \
    -e 's~DT_API_TOKEN.placeholder~'"$DT_API_TOKEN"'~' \
    helm-jenkins.yaml > gen/helm-jenkins.yaml
    # Deploy it

}

echo "Deploying the oneagent via operator..."
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
