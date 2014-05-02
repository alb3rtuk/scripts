#!/bin/sh

# Updates ~/.bash_profile with the bash_profile file found in this repo.
# Scripts/backup/.bash_profile

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/sys/chmod-shell-scripts.sh

cp ~/Repos/Scripts/backup/.bash_profile ~/.bash_profile

message green "SUCCESS" "Bash Profile has been updated. Don't forget to run $ `tput setab 3` . ~/.bash_profile `tput setab 0` or $ `tput setab 3` sb `tput setab 0`"
echo