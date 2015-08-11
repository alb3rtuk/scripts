#!/bin/sh
# Creates a cookbook.

. ~/Repos/scripts/bash/common/utilities.sh

cookbook=$1

if [[ ${cookbook} == "" ]]; then
    message red "ERROR" "You must pass the \033[33mcookbook name\033[0m as the \033[32m1st parameter\033[0m."
    exit
fi

if [[ -d ~/Repos/Chef/cookbooks/${cookbook} ]]; then
    message red "ERROR" "Cookbook with the name: \033[33m${cookbook}\033[0m already exists."
    exit
fi

message blue "KNIFE" "Creating cookbook: \033[33m${cookbook}\033[0m"

metadata_file="cookbooks/${cookbook}/metadata.rb"
default_recipe="cookbooks/${cookbook}/recipes/default.rb"

cd ~/Repos/Chef/

knife cookbook create ${cookbook}
echo "\033[36mCreated skeleton files\033[0m"

# DELETE THE CHANGELOG & README FILES
rm -rf cookbooks/${cookbook}/CHANGELOG.md
rm -rf cookbooks/${cookbook}/README.md
echo "\033[36mDeleted CHANGELOG.md & README.md\033[0m"

# SETUP METADATA FILE
echo "name             '${cookbook}'" > ${metadata_file}
echo "maintainer       'Albert Rannetsperger'" >> ${metadata_file}
echo "maintainer_email 'alb3rtuk@me.com'" >> ${metadata_file}
echo "license          'All rights reserved'" >> ${metadata_file}
echo "description      'Installs/Configures ${cookbook}'" >> ${metadata_file}
echo "version          '0.1.0'" >> ${metadata_file}
echo "\033[36mConfigured\033[0m \033[33m${metadata_file}\033[0m"

# SETUP METADATA FILE
echo "#" > ${default_recipe}
echo "# Cookbook Name:: ${cookbook}" >> ${default_recipe}
echo "# Recipe:: default" >> ${default_recipe}
echo "#" >> ${default_recipe}
echo "# Copyright 2014, Albert Rannetsperger" >> ${default_recipe}
echo "#" >> ${default_recipe}
echo "# All rights reserved - Do Not Redistribute" >> ${default_recipe}
echo "#" >> ${default_recipe}
echo "\033[36mConfigured\033[0m \033[33m${default_recipe}\033[0m"

knife cookbook upload ${cookbook}

git add cookbooks/${cookbook}

exit