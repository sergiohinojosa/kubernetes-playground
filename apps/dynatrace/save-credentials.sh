#!/bin/bash
source ./utils.sh

if [[ $# -eq 3 ]]; then
    # Read JSON and set it in the CREDS variable 
    readCredsFromFile
    DT_TENANT=$1
    DT_API_TOKEN=$2
    DT_INGEST_TOKEN=$3
    echo "Saving the credentials file with following arguments supplied:"
    echo "Dynatrace Tenant: $DT_TENANT"
    echo "Dynatrace API Token: $DT_API_TOKEN"
    echo "Dynatrace Ingest Token: $DT_INGEST_TOKEN"
    echo y | writeCreadsToFile
elif [[ $1 == "show" ]]; then
    readCredsFromFile
    printVariables
else
    readAndReplaceIfNew
fi
