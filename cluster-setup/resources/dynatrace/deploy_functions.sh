#!/bin/bash
#TODO Add the versioning in functions.sh
# Operator Version
OPERATOR_VERSION="v0.13.0"
OPERATOR_YAML="https://github.com/Dynatrace/dynatrace-operator/releases/download/$OPERATOR_VERSION/kubernetes.yaml"

deployOperator() {

    source credentials.sh
    saveReadCredentials
    DT_API_URL="$DT_TENANT/api"

    # Read the actual hostname in case changed during instalation
    CLUSTERNAME=$(hostname)

    # Install the operator
    echo "Deploying the Dynatrace Operator"

    kubectl create namespace dynatrace

    kubectl apply -f $OPERATOR_YAML

    # Save Dynatrace Secret
    kubectl -n dynatrace create secret generic k8s-playground --from-literal="apiToken=$DT_API_TOKEN" --from-literal="dataIngestToken=$DT_INGEST_TOKEN"

    # Replace URL and name for CloudNative and Classic FS Deployment
    # Set HOSTNAME for the K8s Connection

    # Generate DynaKubeSkel with API URL
    sed -e 's~apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api~apiUrl: '"$DT_API_URL"'~' dynakube-skel.yaml >gen/dynakube-skel.yaml

    # ClusterName for API
    sed -i 's~feature.dynatrace.com/automatic-kubernetes-api-monitoring-cluster-name: "CLUSTERNAME"~feature.dynatrace.com/automatic-kubernetes-api-monitoring-cluster-name: "'"$CLUSTERNAME"'"~g' gen/dynakube-skel.yaml
    # Networkzone
    sed -i 's~networkZone: CLUSTERNAME~networkZone: '$CLUSTERNAME'~g' gen/dynakube-skel.yaml
    # HostGroup
    sed -i 's~--set-host-group=CLUSTERNAME~--set-host-group='$CLUSTERNAME'~g' gen/dynakube-skel.yaml
    # ActiveGate Group
    sed -i 's~group: CLUSTERNAME~group: '$CLUSTERNAME'~g' gen/dynakube-skel.yaml
    # Create Dynakube for Classic 
    sed -e 's~MONITORINGMODE:~classicFullStack:~' gen/dynakube-skel.yaml >gen/dynakube-classic.yaml
    # Create Dynakube for CloudNative 
    sed -e 's~MONITORINGMODE:~cloudNativeFullStack:~' gen/dynakube-skel.yaml >gen/dynakube-cloudnative.yaml

    kubectl -n dynatrace wait pod --for=condition=ready --selector=app.kubernetes.io/name=dynatrace-operator,app.kubernetes.io/component=webhook --timeout=300s
}

deployClassic() {
    kubectl -n dynatrace apply -f gen/dynakube-classic.yaml
}

deployCloudNative() {

    kubectl -n dynatrace apply -f gen/dynakube-cloudnative.yaml
}

undeployDynakubes() {
    echo "Undeploying Dynakubes, OneAgent installation from Workernode if installed"

    kubectl -n dynatrace delete dynakube --all

    #kubectl -n dynatrace wait pod --for=condition=delete --selector=app.kubernetes.io/name=oneagent,app.kubernetes.io/managed-by=dynatrace-operator --timeout=300s
    sudo bash /opt/dynatrace/oneagent/agent/uninstall.sh 2>/dev/null
}

uninstallDynatrace() {

    echo "Uninstalling Dynatrace"
    undeployDynakubes

    echo "Uninstalling Dynatrace"
    kubectl delete -f $OPERATOR_YAML

    kubectl delete namespace dynatrace
}

echo "the functions deployOperator deployClassic deployCloudNative undeployDynakubes uninstallDynatrace have been loaded to the current shell"
