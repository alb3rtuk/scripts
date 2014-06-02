#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/secrets_pem.sh
. ~/Repos/Scripts/.secrets/server_host.sh
. ~/Repos/Scripts/.secrets/server_user.sh

echo
message green "EC2" "Running 'update' script on EC2 instance.. \033[33m${EC2_SERVER_HOST}\033[0m"
echo

cd ~/Repos/nimzo-ruby/
git push

ssh -t -l ${EC2_SERVER_USER} -i ${PEM_EU_WEST_1} ${EC2_SERVER_HOST} '
cd ~/Repos/nimzo-ruby/scripts/server;
git pull;
./server-update.sh;
rm -rf ~/Repos/nimzo-ruby/.secrets;
mkdir ~/Repos/nimzo-ruby/.secrets;
rm -rf ~/Repos/nimzo-php/httpdocs/.secrets;
mkdir ~/Repos/nimzo-php/httpdocs/.secrets;
'

# COPY SECRETS TO SERVER
scp -i ${PEM_EU_WEST_1} -r ~/Repos/nimzo-ruby/.secrets/* ${EC2_SERVER_USER}@${EC2_SERVER_HOST}:~/Repos/nimzo-ruby/.secrets
scp -i ${PEM_EU_WEST_1} -r ~/Repos/nimzo-php/httpdocs/.secrets/* ${EC2_SERVER_USER}@${EC2_SERVER_HOST}:~/Repos/nimzo-php/httpdocs/.secrets
scp -i ${PEM_EU_WEST_1} -r ~/Repos/nimzo-java/ebay-service/src/main/resources/eBayAppConfig.properties ${EC2_SERVER_USER}@${EC2_SERVER_HOST}:~/Repos/nimzo-java/ebay-service/src/main/resources/eBayAppConfig.properties

echo
message green "EC2" "Update complete!"
echo