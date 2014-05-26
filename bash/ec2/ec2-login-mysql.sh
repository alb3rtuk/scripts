#!/bin/sh

. /Users/Albert/Repos/Scripts/.secrets/secrets.sh

mysql -h ${EC2_MYSQL_HOST} -P 3306 -u root -p