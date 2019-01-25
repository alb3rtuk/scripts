#!/bin/sh
# SSH'es into my EC2 instance.

. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

echo
message green "EC2" "Logging into EC2 instance.. \033[33m${EC2_SERVER_NIMZO_HOST}\033[0m"
echo

ssh -l ${EC2_SERVER_NIMZO_USER} -i ${PEM_EU_WEST_1} ${EC2_SERVER_NIMZO_HOST}