#!/bin/sh

. /Users/Albert/Repos/Scripts/.secrets/secrets.sh

#time mysql -h ${EC2_MYSQL_HOST} -P 3306 -u root -p${EC2_MYSQL_PASS} -e 'quit'
#time mysql -h nimzo-test.cr27trwznlei.eu-west-1.rds.amazonaws.com -P 3306 -u root -ppassword -e 'quit'
#time mysql -h www.brooklins.com -P 3306 --skip-secure-auth -u brookdata -ptkmdgqps52 -e 'quit'

mysql -h ${EC2_MYSQL_HOST} -P 3306 -u ${EC2_MYSQL_USER} -p${EC2_MYSQL_PASS}