#!/bin/bash
OPERATOR_VERSION="v0.11.2"
KUBERNETES_YAML="https://github.com/Dynatrace/dynatrace-operator/releases/download/$OPERATOR_VERSION/kubernetes.yaml"
CSI_YAML="https://github.com/Dynatrace/dynatrace-operator/releases/download/$OPERATOR_VERSION/kubernetes-csi.yaml"

deployOperator() {

    source credentials.sh 
    saveReadCredentials
    DT_API_URL="$DT_TENANT/api" 

    # Install the operator
    echo "Deploying the Dynatrace Operator"

    kubectl create namespace dynatrace

    kubectl apply -f $KUBERNETES_YAML

    # Download the CSI Driver impl
    curl -o gen/csi.yaml -L $CSI_YAML
    # Changing the destination of the kubelet for Microk8s to deploy the CSI driver succesfully
    sed -e 's~/var/lib/kubelet/~/var/snap/microk8s/common/var/lib/kubelet/~' gen/csi.yaml >gen/microk8s-csi.yaml

    # Save Dynatrace Secret
    kubectl -n dynatrace create secret generic k8s-playground --from-literal="apiToken=$DT_API_TOKEN" --from-literal="dataIngestToken=$DT_INGEST_TOKEN"
    
    if [[ $# -eq 1 ]]; then
        echo "Set Operator for workflow Playground"
        dtcn="k8s-playground-"$TriggerUser""
        sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~; s~feature.dynatrace.com/automatic-kubernetes-api-monitoring-cluster-name: "k8s-playground"~feature.dynatrace.com/automatic-kubernetes-api-monitoring-cluster-name: "'"$dtcn"'"~' dynakube-classic.yaml >gen/dynakube-classic.yaml
        sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~; s~feature.dynatrace.com/automatic-kubernetes-api-monitoring-cluster-name: "k8s-playground"~feature.dynatrace.com/automatic-kubernetes-api-monitoring-cluster-name: "'"$dtcn"'"~' dynakube-cloudnative.yaml >gen/dynakube-cloudnative.yaml

    else
        # Replace URL and name for CloudNative and Classic FS Deployment
        sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~' dynakube-classic.yaml >gen/dynakube-classic.yaml
    
        sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~' dynakube-cloudnative.yaml >gen/dynakube-cloudnative.yaml
    fi 
    kubectl -n dynatrace wait pod --for=condition=ready --selector=app.kubernetes.io/name=dynatrace-operator,app.kubernetes.io/component=webhook --timeout=300s
}

deployClassic() {
    kubectl -n dynatrace apply -f gen/dynakube-classic.yaml
}

deployCloudNative() {
    kubectl -n dynatrace apply -f gen/microk8s-csi.yaml

    kubectl -n dynatrace apply -f gen/dynakube-cloudnative.yaml
}

undeployDynakubes(){
    echo "Undeploying Dynakubes, OneAgent installation from Workernode & CSI Driver if installed"
    kubectl -n dynatrace delete dynakube --all 
    kubectl -n dynatrace delete -f gen/microk8s-csi.yaml 2>/dev/null
    #kubectl -n dynatrace wait pod --for=condition=delete --selector=app.kubernetes.io/name=oneagent,app.kubernetes.io/managed-by=dynatrace-operator --timeout=300s
    sudo bash /opt/dynatrace/oneagent/agent/uninstall.sh 2>/dev/null 
}

uninstallDynatrace() {

    echo "Uninstalling Dynatrace"
    undeployDynakubes

    echo "Uninstalling CSI"
    kubectl delete -f gen/microk8s-csi.yaml

    echo "Uninstalling Dynatrace"
    kubectl delete -f $KUBERNETES_YAML

    kubectl delete namespace dynatrace
}

echo "the functions deployOperator deployClassic deployCloudNative undeployDynakubes uninstallDynatrace have been loaded to the current shell"
