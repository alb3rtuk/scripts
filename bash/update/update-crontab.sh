#!/bin/sh

# Updates the crons using the cron definition file in this Repo
# Scripts/bash/cron/crontab.txt

. ~/Repos/Scripts/bash/common/common-utilities.sh

file="/Users/Albert/Repos/Scripts/backup/crontab.txt"

verifyFileExists $file

cd ~
crontab $file

file_size=$(du ~/Repos/Scripts/backup/crontab.txt | awk '{print $1}');

# If no crons, exit with message.
if [ "$file_size" == "0" ]; then
    echo "`tput setab 4` SUCCESS `tput setab 0` `tput setaf 3`$file`tput setaf 7` is empty so you currently have no crons."
    exit
fi

# If crons, exit and display crons.
OUTPUT=$(crontab -l ARG1 2>&1)
echo "`tput setab 4` SUCCESS `tput setab 0` Crons have been updated. Crontab is now configured to run the followning crons:`tput setaf 3`\n`crontab -l``tput setaf 7`"