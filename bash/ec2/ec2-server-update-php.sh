#!/bin/sh
# Updates all PHP (blufin-php) on my EC2 instance.

. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

echo
message green "EC2/PHP" "Updating PHP on EC2 instance.. \033[33m${EC2_SERVER_BLUFIN_HOST}\033[0m"
echo

cd ~/Repos/blufin-php/
git push

ssh -t -l ${EC2_SERVER_BLUFIN_USER} -i ${PEM_EU_WEST_1} ${EC2_SERVER_BLUFIN_HOST} '
cd $HOME/Repos/blufin-ruby/scripts/server;
./server-update-php.sh;
'

scp -i ${PEM_EU_WEST_1} -r ~/Repos/blufin-php/httpdocs/.secrets/* ${EC2_SERVER_BLUFIN_USER}@${EC2_SERVER_BLUFIN_HOST}:~/Repos/blufin-php/httpdocs/.secrets

echo
message green "EC2" "Update complete!"
echo