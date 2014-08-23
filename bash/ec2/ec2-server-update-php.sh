#!/bin/sh
# Updates all PHP (nimzo-php) on my EC2 instance.

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/secrets_pem.sh
. ~/Repos/Scripts/.secrets/server_host.sh
. ~/Repos/Scripts/.secrets/server_user.sh

echo
message green "EC2/PHP" "Updating PHP on EC2 instance.. \033[33m${EC2_SERVER_HOST}\033[0m"
echo

cd ~/Repos/nimzo-php/
git push

ssh -t -l ${EC2_SERVER_USER} -i ${PEM_EU_WEST_1} ${EC2_SERVER_HOST} '
cd $HOME/Repos/nimzo-ruby/scripts/server;
./server-update-php.sh;
'

scp -i ${PEM_EU_WEST_1} -r ~/Repos/nimzo-php/httpdocs/.secrets/* ${EC2_SERVER_USER}@${EC2_SERVER_HOST}:~/Repos/nimzo-php/httpdocs/.secrets

echo
message green "EC2" "Update complete!"
echo