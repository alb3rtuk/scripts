#!/bin/sh
# Backs up all data on EC2 MySQL instance (blufin) to 'SQL-Backups' repo.

. ~/Repos/scripts/bash/common/utilities.sh
. ~/Repos/blufin-secrets/secrets.sh

date=`date +"%m-%d-%y-%H-%M-%S"`
filename="${EC2_MYSQL_BLUFIN_BACKUP_PATH}blufin-${date}.sql"

echo
message red "EC2" "Backing up MySQL (blufin) instance to \033[33m${filename}\033[0m"

. ~/Repos/scripts/bash/ec2/ec2-mysql-blufin-backup-script.sh > /dev/null 2>&1

echo "      Done.\n"