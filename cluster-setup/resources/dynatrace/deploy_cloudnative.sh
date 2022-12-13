#!/bin/bash


kubectl -n dynatrace apply -f gen/microk8s-csi.yaml

kubectl -n dynatrace apply -f gen/dynakube-cloudnative.yaml

