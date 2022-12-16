# How to un/deploy Dynatrace

## Default settings
By default your instance will be monitored with the Dynatrace credentials you provisioned (`tenant`, `api_token`, `data_ingest_token`) which are required when you monitor a [Kubernetes Cluster with Dynatrace](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-container-platforms/kubernetes/get-started-with-kubernetes-monitoring). 

The default deployment mode is [Classic full-stack injection](dynatrace.com/support/help/setup-and-configuration/setup-on-container-platforms/kubernetes/get-started-with-kubernetes-monitoring/deployment-options-k8s#classic) but you can easily swap to the [CloudNative full-stack injection](https://www.dynatrace.com/support/help/setup-and-configuration/setup-on-container-platforms/kubernetes/get-started-with-kubernetes-monitoring/deployment-options-k8s#cloud-native).

## Dynatrace credentials

The Dynatrace credentials will be passed along during the provisioning and are setted in the [k8splay-install.sh](../../k8splay-install.sh) file. 

```
# ---- Define Dynatrace Environment ----
# Sample: https://{your-domain}/e/{your-environment-id} for managed or https://{your-environment-id}.live.dynatrace.com for SaaS
TENANT=
APITOKEN=
INGESTTOKEN=
```
You can find the above section at the top of the file.

## 🔐 Dynatrace Token Scopes

For ease of deployment is recommended you use the Dynatrace deployment UI `Deployment > Start Installation > Kubernetes`
and you copy/paste:
>APITOKEN="Generated Dynatrace Operator token"
>INGESTTOKEN="Generated Data ingest token"



## 💾 Storage of the credentials during/after provisioning

The Dynatrace credentials are saved in a `configmap` during installation in the `default` namespace. This allows a clean reinstallation even after deleting the namespace `dynatrace` so you can swap the monitoring mode.

```bash
    kubectl create configmap -n default dtcredentials --from-literal=tenant=${DT_TENANT} --from-literal=apiToken=${DT_API_TOKEN} --from-literal=dataIngestToken=${DT_INGEST_TOKEN}
```

> Note: The variables are shuffled (e.g. TENANT -> DT_TENANT,...) inside the functions.sh file for reusability of functions and components. 

## 🔄 Swap deployment mode and work with the deployment functions

If you want to swap the deployment mode from Classic full-stack to CloudNative full-Stack, just navigate to this directory `cd ~/k8s-play/cluster-setup/resources/dynatrace/` and load the deployment functions into your shell `source deploy_functions.sh`. 
You'll see the message

```
the functions deployOperator deployClassic deployCloudNative undeployDynakubes uninstallDynatrace have been loaded to the current shell
```
This means that as long as you don't change the shell, you can execute this functions.
Then run `undeployDynakubes` to delete the dynakubes of the actual installation (will delete the OneAgent, ActiveGates and CSI Drivers). 

Before you deploy the different deployment mode run `kubectl get pod -n dynatrace` to verify that the oneagent has been terminated succesfully (if not you can `--force` the deletion but this is normally not necessary).


After the undeployment is done you can then deploy the CloudNative full-stack deployment by running the command `deployCloudNative`.


## Complete uninstall of Dynatrace
Run `source deploy_functions.sh` and then `uninstallDynatrace`.

## Fresh install of Dynatrace with new Credentials

Run `source credentials.sh` and then `saveReadCredentials $DT_TENANT $DT_API_TOKEN $DT_INGEST_TOKEN`.
This will call the function `saveReadCredentials` and will override the credentials saved as configmap (if any). You can run the `saveReadCredentials` function to verify the values of the configmap.

After you have setted your new credentials then run the function `source deploy_functions.sh && deployOperator` to deploy the operator and then deploy the deployment mode of your liking (either Classic or CloudNative).



