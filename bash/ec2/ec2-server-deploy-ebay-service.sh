#!/bin/sh
# Deploys eBay Service (Java) to EC2 instance.

. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

echo
message green "EC2/JAVA" "Deploying 'ebay-service' to remote Tomcat.. \033[33m${EC2_SERVER_BLUFIN_HOST}\033[0m"
echo

scp -i ${PEM_EU_WEST_1} -r ~/Repos/blufin-java/ebay-service/target/ebay-service.war ${EC2_SERVER_BLUFIN_USER}@${EC2_SERVER_BLUFIN_HOST}:/tmp/

ssh -t -l ${EC2_SERVER_BLUFIN_USER} -i ${PEM_EU_WEST_1} ${EC2_SERVER_BLUFIN_HOST} '
cd /usr/local/tomcat/bin
./shutdown.sh
rm -rf /usr/local/tomcat/webapps/ebay-service;
mkdir /usr/local/tomcat/webapps/ebay-service
mv /tmp/ebay-service.war /usr/local/tomcat/webapps/ebay-service/ebay-service.war
cd /usr/local/tomcat/bin
./startup.sh
'

echo
message green "EC2" "Deployment complete!"
echo