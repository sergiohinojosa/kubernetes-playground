# How to un/deploy Dynatrace


Credentials are saved as configmap on installation on the default namespace, this allows a complete reinstallation even after deleting the namespace `dynatrace`.

    kubectl create configmap -n default dtcredentials --from-literal=tenant=${DT_TENANT} --from-literal=apiToken=${DT_API_TOKEN} --from-literal=dataIngestToken=${DT_INGEST_TOKEN}



# Deploy Dynatrace manually

