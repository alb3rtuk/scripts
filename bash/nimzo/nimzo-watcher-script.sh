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

# Check CSS/Less
if [[ ${storedModifiedTime} != ${lastModifiedTime} ]]; then
    lastModifiedFile=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 2 -d" ")
    find="./"
    replace="public/"
    lastModifiedFile=${lastModifiedFile//${find}/${replace}}
    echo "$(date +"%T") - ${lastModifiedFile}" >> /tmp/nimzo-watcher-log.txt
    echo ${lastModifiedTime} > ${storedModifiedFile}
fi

# Check Sleek
cd ~/Repos/Sleek/httpdocs/
sleekLMT=0
nimzoLMT=0
# Gets the last modified of the Sleek files
dirs=("/Users/Albert/Repos/Sleek/httpdocs/sleek" "/Users/Albert/Repos/Sleek/httpdocs/tests")
for dir in "${dirs[@]}"; do :
    cd ${dir}
    LMT=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 1 -d" ")
    if [[ ${LMT} > ${sleekLMT} ]]; then
        sleekLMT=${LMT}
    fi
done
# Gets the last modified of the Nimzo files
dirs=("/Users/Albert/Repos/Nimzo/httpdocs/private/lib/sleek" "/Users/Albert/Repos/Nimzo/httpdocs/public/dev/lib/app-less/sleek" "/Users/Albert/Repos/Nimzo/httpdocs/public/dev/lib/app-js/sleek" "/Users/Albert/Repos/Nimzo/tests-php/private/lib/sleek")
for dir in "${dirs[@]}"; do :
    cd ${dir}
    LMT=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 1 -d" ")
    if [[ ${LMT} > ${nimzoLMT} ]]; then
        nimzoLMT=${LMT}
    fi
done
cd ~/Repos/Scripts/bash/nimzo
if [[ ${nimzoLMT} > ${sleekLMT} ]]; then
    ./nimzo-update-sleek.sh
fi

tail -30 /tmp/nimzo-watcher-log.txt

# Must run compression at end, so the terminal output looks more neat :)
if [[ ${storedModifiedTime} != ${lastModifiedTime} ]]; then
    cd ~/Repos/Scripts/bash/nimzo
    echo
    ./nimzo-update.sh
fi