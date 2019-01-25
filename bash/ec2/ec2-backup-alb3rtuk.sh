#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

logCron "Attempting to backup/dump 'alb3rtuk' EC2 MySQL DB to local repo."

date="$(date +%Y-%m-%d-%H-%M-%S)"

echo
message blue "EC2-alb3rtuk" "Attempting to dump EC2 MySQL Database..."
echo

mysqldump -u ${EC2_MYSQL_ALB3RTUK_ROOT_USER} -p -P 3306 -h ${EC2_MYSQL_ALB3RTUK_HOST} ${EC2_MYSQL_ALB3RTUK_DEFAULT_SCHEMA} > $HOME/Repos/sql-backups/alb3rtuk/alb3rtuk-${date}.sql

echo
message blue "EC2-alb3rtuk" "Database successfully dumped. Uploading file to GitHub."
echo

cd ~/Repos/sql-backups/
git add .
git status
git commit -m "${date} - Autoscript created SQL backup/dump for EC2 alb3rtuk DB."
git push
git status

echo
message blue "EC2-alb3rtuk" "Upload successful."
echo