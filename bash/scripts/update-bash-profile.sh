#!/bin/sh
# Updates ~/.bash_profile with the the content of ~/Repos/scripts/backup/.bash_profile & pulls in 'nimzo' aliases as well.

. ~/Repos/scripts/bash/common/utilities.sh

if [[ ! -f ~/Repos/nimzo-ruby/config/.bashrc_shared ]]; then
    echo
    message red "ERROR" "Cannot find the following file: \033[33m~/Repos/nimzo-ruby/config/.bashrc_shared\033[0m"
    echo
    exit
fi

. ~/Repos/scripts/bash/sys/chmod-shell-scripts.sh

# Include the NIMZO aliases.
bash_profile=`cat ~/Repos/scripts/backup/.bash_profile`
bashrc_aliases=`cat ~/Repos/nimzo-ruby/config/.bashrc_shared`
find=">>> NIMZO ALIASES <<<"
bash_final=${bash_profile//${find}/${bashrc_aliases}}

echo "${bash_final}" > ~/.bash_profile

message green "SUCCESS" "Bash Profile has been updated. Don't forget to run $ `tput setab 3` . ~/.bash_profile `tput setab 0` or $ `tput setab 3` sb `tput setab 0`"
echo