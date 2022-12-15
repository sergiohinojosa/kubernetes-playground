#!/bin/bash

# Read the domain from CM
source ../util/loaddomain.sh

#Default values
GIT_USER="k8splay"
GIT_PASSWORD="k8splay"
GIT_SERVER="http://git.$DOMAIN"

# static vars
GIT_TOKEN="k8splay-token"
TOKEN_FILE=$GIT_TOKEN.json

echo "Username: $GIT_USER"
echo "Password: $GIT_PASSWORD"
echo "GIT-Server: $GIT_SERVER" 



