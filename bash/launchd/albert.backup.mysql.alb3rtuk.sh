#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/secrets.sh

logCron "Attempting to backup/dump 'alb3rtuk' EC2 MySQL DB to local repo."

date="$(date +%Y-%m-%d)"

mysqldump -h ${EC2_MYSQL_ALB3RTUK_HOST} -P 3306 -u ${EC2_MYSQL_ALB3RTUK_ROOT_USER} -p${EC2_MYSQL_ALB3RTUK_ROOT_PASS} ${EC2_MYSQL_ALB3RTUK_DEFAULT_SCHEMA} > $HOME/Repos/SQL-Backups/alb3rtuk/alb3rtuk-${date}.sql