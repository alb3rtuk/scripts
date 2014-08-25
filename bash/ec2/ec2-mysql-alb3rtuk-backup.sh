#!/bin/sh
# Backs up all data on EC2 MySQL instance (alb3rtuk) to 'SQL-Backups' repo.

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/secrets.sh

echo
message red "EC2" "Backing up MySQL instance.. \033[33m${EC2_MYSQL_ALB3RTUK_HOST}\033[0m"
echo

mysql -h ${EC2_MYSQL_ALB3RTUK_HOST} -P 3306 --skip-secure-auth -u ${EC2_MYSQL_ALB3RTUK_ROOT_USER} -p${EC2_MYSQL_ALB3RTUK_ROOT_PASS}