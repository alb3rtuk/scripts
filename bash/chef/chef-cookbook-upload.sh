#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cookbook=$1

if [[ ${cookbook} == "" ]]; then
    message red "ERROR" "You must pass the \033[33mcookbook name\033[0m as the \033[32m1st parameter\033[0m."
    exit
fi

if [[ ! -d ~/Repos/Chef/cookbooks/${cookbook} ]]; then
    message red "ERROR" "Cookbook with the name: \033[33m${cookbook}\033[0m doesn't exist."
    exit
fi

message blue "KNIFE" "Uploading cookbook: \033[33m${cookbook}\033[0m"

metadata_file="cookbooks/${cookbook}/metadata.rb"

cd ~/Repos/Chef/

ruby ~/Repos/Scripts/ruby/chef/cookbook-version-incrementer.rb ${metadata_file}

knife cookbook delete ${cookbook} -y
knife cookbook upload ${cookbook}

git add cookbooks/${cookbook}

exit