#!/bin/sh

# Updates the launchd directory automatically by creating symlinks to .plist files in this Repo.
# Only touches launchd jobs that start with albert.*

. ~/Repos/Scripts/bash/common/utilities.sh

plistDirectory="/Users/Albert/Repos/Scripts/launchd/"
launchdDirectory="/Users/Albert/Library/LaunchAgents/"

# First, remove all launchd jobs and symbolic links from LaunchAgents directory.
cd ${launchdDirectory}
for input in $(ls -lR ${launchdDirectory} | grep ^l); do
    if [[ ${input} == albert.*.plist ]]; then
        rm ${input}
        inputLength=${#input}
        inputLength=`expr ${inputLength} - 6`
        launchctl remove ${input:0:${inputLength}}
    fi
done

# Second, recreate all launchd jobs from the files in the git repo.
cd ${plistDirectory}
for input in $(find . -type f -name "albert.*.plist"); do
    ln -s ${plistDirectory}${input:2} ${launchdDirectory}${input:2}
    launchctl load ${launchdDirectory}${input:2}
    inputLength=${#input}
    inputLength=`expr ${inputLength} - 8`
    message green "REGISTERED LAUNCHD" "`tput setaf 3`${input:2:$inputLength}"
done
exit
