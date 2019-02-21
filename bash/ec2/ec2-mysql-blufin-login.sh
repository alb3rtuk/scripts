#!/bin/sh
# Logs me into my EC2 MySQL instance (blufin).

. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

#Latenct test
#time mysql -h ${EC2_MYSQL_BLUFIN_HOST} -P 3306 -u root -p${EC2_MYSQL_BLUFIN_ROOT_PASS} -e 'quit'
#time mysql -h blufin-test.cr27trwznlei.eu-west-1.rds.amazonaws.com -P 3306 -u root -ppassword -e 'quit'
#time mysql -h www.brooklins.com -P 3306 --skip-secure-auth -u brookdata -ptkmdgqps52 -e 'quit'

echo
message green "EC2" "Logging into MySQL instance.. \033[33m${EC2_MYSQL_BLUFIN_HOST}\033[0m"
echo

mysql -h ${EC2_MYSQL_BLUFIN_HOST} -P 3306 --skip-secure-auth -u ${EC2_MYSQL_BLUFIN_ROOT_USER} -p${EC2_MYSQL_BLUFIN_ROOT_PASS}