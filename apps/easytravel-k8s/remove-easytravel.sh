#!/bin/bash

kubectl -n easytravel delete -f manifests/
kubectl delete ns easytravel