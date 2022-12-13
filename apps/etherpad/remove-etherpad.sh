#!/bin/bash
# Usage: sh remove-etherpad.sh
# will remove the Etherpad application
kubectl -n etherpad delete -f .
rm 03-etherpad-ingress-gen.yaml