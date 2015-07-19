#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/secrets.sh

logCron "Attempting to backup/dump 'alb3rtuk' EC2 MySQL DB to local repo."

date="$(date +%Y-%m-%d-%H-%M-%S)"

mysqldump -u ${EC2_MYSQL_ALB3RTUK_ROOT_USER} -p${EC2_MYSQL_ALB3RTUK_ROOT_PASS} -P 3306 -h ${EC2_MYSQL_ALB3RTUK_HOST} ${EC2_MYSQL_ALB3RTUK_DEFAULT_SCHEMA} > $HOME/Repos/sql-backups/alb3rtuk/alb3rtuk-${date}.sql

cd ~/Repos/sql-backups/

git add .
git commit -m "${date} - Autoscript created SQL backup/dump for EC2 alb3rtuk DB."
git push

exit
