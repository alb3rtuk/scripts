#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cookbook=$1

if [[ $cookbook == "" ]]; then
    message red "ERROR" "No cookbook (1st parameter) has been defined."
    exit
fi

cd ~/Repos/Chef/

# CHECK IF COOKBOOK ALREADY EXISTS
if [[ -d ~/Repos/Chef/cookbooks/${cookbook} ]]; then
    read -p "`echo "\`tput setab 1\` WARNING \`tput setab 0\` The cookbook: \033[33m${cookbook}\033[0m already exists. Continue anyway & overwrite current version? \033[32m[y/n]\033[0m \033[37m=>\033[0m "`" -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "`tput setab 1` SCRIPT WAS ABORTED `tput setab 0`"
        exit
    fi
fi

mkdir tmp
cd tmp
knife cookbook site download ${cookbook}
echo "\033[36mDownloaded cookbook: \033[33m${cookbook}\033[0m \033[36mfrom the Chef server\033[0m"

for file in ~/Repos/Chef/tmp/*
do
    tar xzvf ${file} -C ~/Repos/Chef/cookbooks/
done
echo "\033[36mExtracted .tar file\033[0m"

cd ~/Repos/Chef/
rm -rf tmp/

knife cookbook upload ${cookbook}
echo "Uploaded cookbook to Chef server"

git add cookbooks/${cookbook}
git commit cookbooks/${cookbook} -m "Download/Added a new cookbook: $cookbook"
git push
echo "\033[36mCommited & pushed revision to GitHub repo\033[0m"

exit