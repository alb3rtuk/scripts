#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cookbook=$1

if [[ $cookbook == "" ]]; then
    message red "ERROR" "No cookbook (1st parameter) has been defined."
    exit
fi

cd ~/Repos/Chef/

# ONLY DOWNLOAD & UNZIP COOKBOOK IF IT DOESN'T EXIST.
if [[ ! -d ~/Repos/Chef/cookbooks/${cookbook} ]]; then
    mkdir tmp
    cd tmp
    knife cookbook site download ${cookbook}

    for file in ~/Repos/Chef/tmp/*
    do
        tar xzvf ${file} -C ~/Repos/Chef/cookbooks/
    done

    cd ~/Repos/Chef/
    rm -rf tmp/

    git add cookbooks/${cookbook}
    git commit -m "Added cookbook: $cookbook"
    git push
else
    echo "Cookbook: \033[33m${cookbook}\033[0m has already been downloaded."
fi

knife cookbook upload ${cookbook}

exit