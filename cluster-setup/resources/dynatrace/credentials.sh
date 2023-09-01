#!/bin/bash

saveReadCredentials() {
    echo "If credentials are passed as arguments they will be overwritten and saved as ConfigMap"
    echo "else they will be read from the ConfigMap and exported as env Variables"
    if [[ $# -eq 3 ]]; then
        DT_TENANT=$1
        DT_API_TOKEN=$2
        DT_INGEST_TOKEN=$3
        echo "Saving the credentials ConfigMap dtcredentials -n default with following arguments supplied: @"

        kubectl delete configmap -n default dtcredentials 2>/dev/null
        kubectl create configmap -n default dtcredentials --from-literal=tenant=${DT_TENANT} --from-literal=apiToken=${DT_API_TOKEN} --from-literal=dataIngestToken=${DT_INGEST_TOKEN}
    else
        echo "No arguments passed, getting them from the ConfigMap"
        kubectl get configmap -n default dtcredentials 2>/dev/null
        if [[ $? -eq 0 ]]; then
            DT_TENANT=$(kubectl get configmap -n default dtcredentials -ojsonpath={.data.tenant})
            DT_API_TOKEN=$(kubectl get configmap -n default dtcredentials -ojsonpath={.data.apiToken})
            DT_INGEST_TOKEN=$(kubectl get configmap -n default dtcredentials -ojsonpath={.data.dataIngestToken})
        else
            echo "ConfigMap not found, resetting variables"
            unset DT_TENANT DT_API_TOKEN DT_INGEST_TOKEN
        fi
    fi
    echo "Dynatrace Tenant: $DT_TENANT"
    echo "Dynatrace API & PaaS Token: $DT_API_TOKEN"
    echo "Dynatrace Ingest Token: $DT_INGEST_TOKEN"
    export DT_TENANT=$DT_TENANT
    export DT_API_TOKEN=$DT_API_TOKEN
    export DT_INGEST_TOKEN=$DT_INGEST_TOKEN
    if [ -n "${TriggerUser}" ]; then
        echo "Set Operator for workflow Playground"
        export TriggerUser=$triggeruser
    fi   

    
}
