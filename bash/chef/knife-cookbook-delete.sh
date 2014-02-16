#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cookbook=$1

if [[ $cookbook == "" ]]; then
    message red "ERROR" "No cookbook (1st parameter) has been defined."
    exit
fi

cd ~/Repos/Chef/cookbooks/

knife cookbook delete ${cookbook}

rm -rf ${cookbook}

git commit -a -m "Removed cookbook: $cookbook"
git push

exit