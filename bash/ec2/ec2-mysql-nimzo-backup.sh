#!/bin/sh
# Backs up all data on EC2 MySQL instance (nimzo) to 'SQL-Backups' repo.

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/.secrets/secrets.sh

date=`date +"%m-%d-%y-%H-%M-%S"`
filename="${EC2_MYSQL_NIMZO_BACKUP_PATH}nimzo-${date}.sql"

echo
message red "EC2" "Backing up MySQL (nimzo) instance to \033[33m${filename}\033[0m"

. ~/Repos/Scripts/bash/ec2/ec2-mysql-nimzo-backup-script.sh > /dev/null 2>&1

echo "      Done.\n"