#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cookbook=$1

if [[ $cookbook == "" ]]; then
    message red "ERROR" "You must pass the \033[33mcookbook name\033[0m as the \033[32m1st parameter\033[0m."
    exit
fi

if [[ ! -d ~/Repos/Chef/cookbooks/${cookbook} ]]; then
    message red "ERROR" "The cookbook: \033[33m${cookbook}\033[0m doesn't seem to exist."
    exit
fi

read -p "`echo "\`tput setab 1\` WARNING \`tput setab 0\` \033[0mYou are about to permanently delete the cookbook: \033[33m${cookbook}\033[0m. \033[31mThis action cannot be undone!\033[0m Continue? \033[32m[y/n]\033[0m \033[37m=>\033[0m "`" -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "`tput setab 1` SCRIPT WAS ABORTED `tput setab 0`"
    exit
fi

cd ~/Repos/Chef

knife cookbook delete ${cookbook}
echo "\033[36mRemoved: \033[33m${cookbook}\033[36m from Chef server\033[0m"

rm -rf cookbooks/${cookbook}
echo "\033[36mDeleted:\033[0m \033[33mcookbooks/${cookbook}\033[0m"

git add cookbooks/${cookbook} --all
git commit -o cookbooks/${cookbook} -m "Removed cookbook: $cookbook"
git push
echo "\033[36mCommited & pushed revision to GitHub repo\033[0m"

exit