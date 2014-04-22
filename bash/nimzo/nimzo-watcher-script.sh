#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo/httpdocs/public/dev

lastScriptRun=$(date +"%T %Z")
lastModifiedTime=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 1 -d" ")

storedModifiedFile="/tmp/nimzo-watcher-last-change.txt"

if [[ -f ${storedModifiedFile} ]]; then
    storedModifiedTime=$(cat ${storedModifiedFile})
else
    storedModifiedTime=0
fi

echo "Checking for changes within: ~/Repos/Nimzo/httpdocs/public/dev"
echo
echo "Last script run:  ${lastScriptRun}"

if [[ ${storedModifiedTime} != ${lastModifiedTime} ]]; then
    lastModifiedFile=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 2 -d" ")
    find="./"
    replace="public/"
    lastModifiedFile=${lastModifiedFile//${find}/${replace}}
    echo "$(date +"%T") - ${lastModifiedFile}" >> /tmp/nimzo-watcher-log.txt
    echo ${lastModifiedTime} > ${storedModifiedFile}
fi

tail -30 /tmp/nimzo-watcher-log.txt

# Must run compression at end, so the terminal output looks more neat :)
if [[ ${storedModifiedTime} != ${lastModifiedTime} ]]; then
    cd ~/Repos/Scripts/bash/nimzo
    echo
    ./nimzo-update.sh
fi