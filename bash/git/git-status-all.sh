#!/bin/sh
# Gets the status of all my Git repos.

. ~/Repos/scripts/bash/common/utilities.sh

message red " DEPRECATED " "This script is deprecated."
exit

echo
message magenta " GIT " "Getting status of all repos... \033[33m$(date +"%a %e %b %Y %H:%M:%S")\033[0m"
echo

repos=(brightpearl-cli columnist convoy factory-mall finance-report my-cli nimzo-java nimzo-node nimzo-php nimzo-ruby scripts shared)

for i in "${repos[@]}"
do :
    echo
    echo "\033[35m~/Repos/${i}/\033[0m"
    cd ~/Repos/${i}/
    git status
done

echo