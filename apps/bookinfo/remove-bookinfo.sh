#!/bin/bash
# Set up of the Book application of istio for Microk8s
# https://istio.io/docs/examples/bookinfo/

# undeploy app
kubectl -n bookinfo delete -f manifests/

# we delete the ns
kubectl delete ns bookinfo
 