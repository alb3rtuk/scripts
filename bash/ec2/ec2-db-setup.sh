#!/bin/sh

# Script to setup nimzo-app user on a new DB instance.

. /Users/Albert/Repos/Scripts/.secrets/secrets.sh

mysql -h ${EC2_MYSQL_HOST} -P 3306 -u root -p -e " \
CREATE USER '${EC2_MYSQL_APP_USER}'@'%' IDENTIFIED BY '${EC2_MYSQL_APP_PASS}';
GRANT SELECT ON mysql.user TO '${EC2_MYSQL_APP_USER}'@'%';
GRANT INSERT ON mysql.user TO '${EC2_MYSQL_APP_USER}'@'%';
GRANT DELETE ON mysql.user TO '${EC2_MYSQL_APP_USER}'@'%';
GRANT UPDATE ON mysql.user TO '${EC2_MYSQL_APP_USER}'@'%';
quit"