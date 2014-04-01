#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo/httpdocs/public/dev

lastScriptRun=$(date +"%T %Z")
lastModifiedTime=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 1 -d" ")

storedModifiedTime=$(cat /tmp/nimzo-watcher-last-change.txt)

echo "Checking for changes within: ~/Repos/Nimzo/httpdocs/public/dev"
echo
echo "Last script run:  ${lastScriptRun}"

if [[ ${storedModifiedTime} != ${lastModifiedTime} ]]; then
    lastModifiedFile=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 2 -d" ")
    find="./"
    replace="pubic/"
    lastModifiedFile=${lastModifiedFile//$find/$replace}

    echo "$(date +"%T") - ${lastModifiedFile}" >> /tmp/nimzo-watcher-log.txt

fi

echo
tail -10 /tmp/nimzo-watcher-log.txt

echo ${lastModifiedTime} > /tmp/nimzo-watcher-last-change.txt