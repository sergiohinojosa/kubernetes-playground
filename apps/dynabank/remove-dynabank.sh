#!/bin/bash
kubectl -n dbic delete -f manifests/
kubectl delete ns dbic
