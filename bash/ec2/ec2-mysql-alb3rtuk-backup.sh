#!/bin/sh
# Backs up all data on EC2 MySQL instance (alb3rtuk) to 'SQL-Backups' repo.

. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

date=`date +"%m-%d-%y-%H-%M-%S"`
filename="${EC2_MYSQL_ALB3RTUK_BACKUP_PATH}alb3rtuk-${date}.sql"

echo
message red "EC2" "Backing up MySQL (alb3rtuk) instance to \033[33m${filename}\033[0m"

. ~/Repos/scripts/bash/ec2/ec2-mysql-alb3rtuk-backup-script.sh > /dev/null 2>&1

echo "      Done.\n"