#!/bin/sh
# Gets the status of all my Git repos.

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message magenta " GIT " "Getting status of all repos... \033[33m$(date +"%a %e %b %Y %H:%M:%S")\033[0m"
echo

repos=(brightpearl-cli columnist convoy nimzo-java nimzo-node nimzo-php nimzo-php-docs nimzo-ruby scripts)

for i in "${repos[@]}"
do :
    echo
    echo "\033[35m~/Repos/${i}/\033[0m"
    cd ~/Repos/${i}/
    git status
done

echo