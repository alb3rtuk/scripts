#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/secrets_pem.sh
. ~/Repos/Scripts/.secrets/server_host.sh
. ~/Repos/Scripts/.secrets/server_user.sh

echo
message green "EC2" "Copying important files to EC2 instance.. \033[33m${EC2_SERVER_HOST}\033[0m"
echo

ssh -l ${EC2_SERVER_USER} -i ${PEM_EU_WEST_1} ${EC2_SERVER_HOST}