#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

echo "$(date +"%T") - Synced Sleek files" >> /tmp/nimzo-watcher-log.txt

nimzoRepo="/Users/Albert/Repos/Nimzo/"
sleekRepo="/Users/Albert/Repos/Sleek/httpdocs/"

# Wipe Sleek Repo
rm -rf ${sleekRepo}sleek/library
rm -rf ${sleekRepo}sleek/shared
rm -rf ${sleekRepo}sleek/js
rm -rf ${sleekRepo}sleek/less

mkdir ${sleekRepo}sleek/library
mkdir ${sleekRepo}sleek/shared
mkdir ${sleekRepo}sleek/js
mkdir ${sleekRepo}sleek/less

if [[ ! -f ${sleekRepo}sleek/css/sleek.css ]]; then
    mkdir ${sleekRepo}sleek/css
    touch ${sleekRepo}sleek/css/sleek.css
    cd ~/Repos/Sleek/
    git add ${sleekRepo}sleek/css/sleek.css
fi

# Copy files
cp -r ${nimzoRepo}httpdocs/private/lib/sleek/library/* ${sleekRepo}sleek/library
cp -r ${nimzoRepo}httpdocs/private/lib/sleek/shared/* ${sleekRepo}sleek/shared
cp -r ${nimzoRepo}httpdocs/public/dev/lib/app-js/sleek/* ${sleekRepo}sleek/js
cp -r ${nimzoRepo}httpdocs/public/dev/lib/app-less/sleek/* ${sleekRepo}sleek/less

lessc ${sleekRepo}sleek/less/sleek.less > ${sleekRepo}sleek/css/sleek.css -x -s