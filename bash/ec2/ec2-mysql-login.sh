#!/bin/sh
# Logs me into my EC2 MySQL instance.

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/mysql_host.sh
. ~/Repos/Scripts/.secrets/mysql_user_root.sh

#Latenct test
#time mysql -h ${EC2_MYSQL_HOST} -P 3306 -u root -p${EC2_MYSQL_ROOT_PASS} -e 'quit'
#time mysql -h nimzo-test.cr27trwznlei.eu-west-1.rds.amazonaws.com -P 3306 -u root -ppassword -e 'quit'
#time mysql -h www.brooklins.com -P 3306 --skip-secure-auth -u brookdata -ptkmdgqps52 -e 'quit'

echo
message green "EC2" "Logging into MySQL instance.. \033[33m${EC2_MYSQL_HOST}\033[0m"
echo

mysql -h ${EC2_MYSQL_HOST} -P 3306 -u ${EC2_MYSQL_ROOT_USER} -p${EC2_MYSQL_ROOT_PASS}