#!/bin/bash
# Usage: sh deploy-frontail.sh
# Bash to prepare and deploy the Tail -f application for streaming the history file
# Application https://github.com/mthenw/frontail

# Create directory for the Persistent Volume
mkdir /tmp/pv-data/
# Adapt the access rights
chmod 755 -R /tmp/pv-data
# Identify the user
USER=$(whoami)
# Change ownership
chown $USER:$USER /tmp/pv-data
# Write in the history file after each command (dont keep in memory)
export PROMPT_COMMAND='history -a'
# Make hardlink
ln  ~/.bash_history /tmp/pv-data/history.log

# Read the domain from CM
source ../util/loaddomain.sh

kubectl create ns fronttail

sed 's~domain.placeholder~'"$DOMAIN"'~' 05-frontail-ingress.template > 05-frontail-ingress-gen.yaml

kubectl -n fronttail apply -f .
echo "Frontail service available at:"
kubectl -n fronttail get ing frontail-ingress