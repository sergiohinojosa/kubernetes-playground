#!/bin/bash

kubectl -n hipstershop delete -f manifests/

kubectl delete ns hipstershop