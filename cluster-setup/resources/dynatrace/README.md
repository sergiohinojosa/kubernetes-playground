# How to un/deploy Dynatrace

## Default settings
By default your instance will be monitored with the Dynatrace credentials you provisioned (`tenant`, `api_token`, `data_ingest_token`) which are required when you monitor a [Kubernetes Cluster with Dynatrace](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-container-platforms/kubernetes/get-started-with-kubernetes-monitoring). 

The default deployment mode is [Classic full-stack injection](dynatrace.com/support/help/setup-and-configuration/setup-on-container-platforms/kubernetes/get-started-with-kubernetes-monitoring/deployment-options-k8s#classic) but you can easily swap to the [CloudNative full-stack injection](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-container-platforms/kubernetes/get-started-with-kubernetes-monitoring/deployment-options-k8s#cloud-native).

## Dynatrace credentials

The Dynatrace credentials will be passed along during the provisioning and are setted in the [k8splay-install.sh](../../k8splay-install.sh) file. You can find the section at the beginning of the file:

```
# ---- Define Dynatrace Environment ----
# Sample: https://{your-domain}/e/{your-environment-id} for managed or https://{your-environment-id}.live.dynatrace.com for SaaS
TENANT=
APITOKEN=
INGESTTOKEN=
```

### Dynatrace Token Scopes
For ease of deployment is recommended you use the Dynatrace deployment UI `Deployment > Start Installation > Kubernetes`
and you copy/paste:

Dynatrace Operator token > APITOKEN
Data ingest token        > INGESTTOKEN

### Storage of the credentials after provisioning

The Dynatarce credentials are saved as `configmap` on installation on the `default` namespace, this allows a clean reinstallation even after deleting the namespace `dynatrace`.
```bash
    kubectl create configmap -n default dtcredentials --from-literal=tenant=${DT_TENANT} --from-literal=apiToken=${DT_API_TOKEN} --from-literal=dataIngestToken=${DT_INGEST_TOKEN}
```



# Deploy Dynatrace manually

