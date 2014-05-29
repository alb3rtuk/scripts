#!/bin/sh

# Updates ~/.bash_profile with the bash_profile file found in this repo.
# Scripts/backup/.bash_profile

. ~/Repos/Scripts/bash/common/utilities.sh

if [[ ! -f ~/Repos/nimzo-ruby/config/.bashrc_aliases ]]; then
    echo
    message red "ERROR" "Cannot find the following file: \033[33m~/Repos/nimzo-ruby/config/.bashrc_aliases\033[0m"
    echo
    exit
fi

. ~/Repos/Scripts/bash/sys/chmod-shell-scripts.sh

# Include the NIMZO aliases.
bash_profile=`cat ~/Repos/Scripts/backup/.bash_profile`
bashrc_aliases=`cat ~/Repos/nimzo-ruby/config/.bashrc_aliases`
find=">>> NIMZO ALIASES <<<"
bash_final=${bash_profile//${find}/${bashrc_aliases}}

echo "${bash_final}" > ~/.bash_profile

message green "SUCCESS" "Bash Profile has been updated. Don't forget to run $ `tput setab 3` . ~/.bash_profile `tput setab 0` or $ `tput setab 3` sb `tput setab 0`"
echo