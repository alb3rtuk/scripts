#!/bin/sh
# Updates all scripts (blufin-ruby) on my EC2 instance.


. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

echo
message green "EC2" "Running 'update' script on EC2 instance.. \033[33m${EC2_SERVER_BLUFIN_HOST}\033[0m"
echo

cd ~/Repos/blufin-ruby/
git push

# COPY YUI-COMPRESSOR TO SERVER
scp -i ${PEM_EU_WEST_1} -r ~/Repos/blufin-ruby/config/yuicompressor-2.4.8.jar ${EC2_SERVER_BLUFIN_USER}@${EC2_SERVER_BLUFIN_HOST}:/tmp/yuicompressor-2.4.8.jar

ssh -t -l ${EC2_SERVER_BLUFIN_USER} -i ${PEM_EU_WEST_1} ${EC2_SERVER_BLUFIN_HOST} '
sudo mv /tmp/yuicompressor-2.4.8.jar /bin/yuicompressor-2.4.8.jar;
sudo chmod 0755 /bin/yuicompressor-2.4.8.jar;
cd ~/Repos/blufin-ruby/scripts/server;
git stash;
git stash drop;
git pull;
./server-update.sh;
rm -rf ~/Repos/blufin-ruby/.secrets;
mkdir ~/Repos/blufin-ruby/.secrets;
'

# COPY SECRETS TO SERVER
scp -i ${PEM_EU_WEST_1} -r ~/Repos/blufin-ruby/.secrets/* ${EC2_SERVER_BLUFIN_USER}@${EC2_SERVER_BLUFIN_HOST}:~/Repos/blufin-ruby/.secrets
#scp -i ${PEM_EU_WEST_1} -r ~/Repos/blufin-php/httpdocs/.secrets/* ${EC2_SERVER_BLUFIN_USER}@${EC2_SERVER_BLUFIN_HOST}:~/Repos/blufin-php/httpdocs/.secrets
#scp -i ${PEM_EU_WEST_1} -r ~/Repos/blufin-java/ebay-service/src/main/resources/eBayAppConfig.properties ${EC2_SERVER_BLUFIN_USER}@${EC2_SERVER_BLUFIN_HOST}:~/Repos/blufin-java/ebay-service/src/main/resources/eBayAppConfig.properties

echo
message green "EC2" "Update complete!"
echo