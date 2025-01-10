#!/bin/bash
#TODO Add the versioning in functions.sh
# Operator Version
OPERATOR_VERSION="v1.3.2"
OPERATOR_YAML="https://github.com/Dynatrace/dynatrace-operator/releases/download/$OPERATOR_VERSION/kubernetes.yaml"
CSI_YAML="https://github.com/Dynatrace/dynatrace-operator/releases/download/$OPERATOR_VERSION/kubernetes-csi.yaml"

deployOperator() {

    source credentials.sh
    saveReadCredentials
    DT_API_URL="$DT_TENANT/api"

    # Read the actual hostname in case changed during instalation
    CLUSTERNAME=$(hostname)

    # Install the operator
    echo "Deploying the Dynatrace Operator Version $OPERATOR_VERSION"

    kubectl create namespace dynatrace

    kubectl apply -f $OPERATOR_YAML

    # Download the CSI Driver impl
    curl -o gen/csi.yaml -L $CSI_YAML
    # Changing the destination of the kubelet for Microk8s to deploy the CSI driver succesfully
    sed -e 's~/var/lib/kubelet/~/var/snap/microk8s/common/var/lib/kubelet/~' gen/csi.yaml >gen/microk8s-csi.yaml

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
    
}

deployClassic() {
    
    # Check if the Webhook has been created and is ready
    kubectl -n dynatrace wait pod --for=condition=ready --selector=app.kubernetes.io/name=dynatrace-operator,app.kubernetes.io/component=webhook --timeout=300s

    kubectl -n dynatrace apply -f gen/dynakube-classic.yaml
}

deployCloudNative() {

    kubectl -n dynatrace apply -f gen/microk8s-csi.yaml
    # Check if the Webhook has been created and is ready
    kubectl -n dynatrace wait pod --for=condition=ready --selector=app.kubernetes.io/name=dynatrace-operator,app.kubernetes.io/component=webhook --timeout=300s

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

    kubectl -n dynatrace delete -f gen/microk8s-csi.yaml 2>/dev/null

    kubectl delete namespace dynatrace
}

waitForAllPods() {
  # Function to filter by Namespace, default is ALL
  if [[ $# -eq 1 ]]; then
    namespace_filter="-n $1"
  else
    namespace_filter="--all-namespaces"
  fi
  RETRY=0
  RETRY_MAX=24
  # Get all pods, count and invert the search for not running nor completed. Status is for deleting the last line of the output
  CMD="bashas \"kubectl get pods $namespace_filter 2>&1 | grep -c -v -E '(Running|Completed|Terminating|STATUS)'\""
  printInfo "Checking and wait for all pods in \"$namespace_filter\" to run."
  while [[ $RETRY -lt $RETRY_MAX ]]; do
    pods_not_ok=$(eval "$CMD")
    if [[ "$pods_not_ok" == '0' ]]; then
      printInfo "All pods are running."
      break
    fi
    RETRY=$(($RETRY + 1))
    printWarn "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for $pods_not_ok PoDs to finish or be in state Running ..."
    sleep 10
  done

  if [[ $RETRY == $RETRY_MAX ]]; then
    printError "Following pods are not still not running. Please check their events. Exiting installation..."
    bashas "kubectl get pods --field-selector=status.phase!=Running -A"
    exit 1
  fi
}

echo "the functions deployOperator deployClassic deployCloudNative undeployDynakubes uninstallDynatrace have been loaded to the current shell"
