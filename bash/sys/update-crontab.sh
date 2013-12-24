#!/bin/sh

# Updates the crons using the cron definition file in this Repo.
# Fount at: ~/Repos/Scripts/bash/cron/crontab.txt

. ~/Repos/Scripts/bash/common/common-utilities.sh

file="/Users/Albert/Repos/Scripts/backup/crontab.txt"

verifyFileExists $file

cd ~
crontab $file

file_size=$(du ~/Repos/Scripts/backup/crontab.txt | awk '{print $1}');

# If no crons, exit with message.
if [ "$file_size" == "0" ]; then
    message red "NO CRONS FOUND" "`tput setaf 3`$file\033[0m is empty so you currently have no crons."
    exit
fi

# If crons, exit and display crons.
crontab -l > /var/tmp/tmp-crontab.txt

while read cron; do
    message green "REGISTERED CRON" "`tput setaf 3`$cron"
done < /var/tmp/tmp-crontab.txt

rm /var/tmp/tmp-crontab.txt
exit 0