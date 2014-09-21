#!/bin/sh
# Renames all files in current directory sequentially.

. ~/Repos/Scripts/bash/common/utilities.sh

prefix=$1
cnt=0

if [[ ${prefix} == "" ]]; then
    echo
    message red "ERROR" "Script expects first parameter to be the prefix. For example:\n"
    echo "        \033[33mAmerican.Dad.Se08.E\033[0m"
    echo "        \033[33mFamily.Guy.Se12.E\033[0m"
    echo
    exit
fi

echo
for fname in *; do
    cnt=$((${cnt} + 1))
    cntDisplay=$(printf %02d ${cnt})
    ext="${fname##*.}"
    echo "\033[32m${prefix}${cntDisplay}.${ext}\033[0m < \033[37m${fname}\033[0m"
done
echo

read -p "`echo "\`tput setab 1\` WARNING \`tput setab 0\` \033[0mYou are about to permanently rename these files. \033[31mThis action cannot be undone!\033[0m Continue? \033[32m[y/n]\033[0m \033[37m=>\033[0m "`" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    cnt=0
    for fname in *; do
        if [ -e "${fname}" ] ; then
            cnt=$((${cnt} + 1))
            cntDisplay=$(printf %02d ${cnt})
            ext="${fname##*.}"

            # Escapes spaces with a backslash in the original filename. IE: ' ' becomes '\ '
            # fname=${fname// /\\ }

            `mv "${fname}" "${prefix}${cntDisplay}.${ext}"`
            echo "Renamed: \033[32m${prefix}${cntDisplay}.${ext}\033[0m"
        fi
    done
    echo
else
    echo
    echo "`tput setab 1` SCRIPT WAS ABORTED `tput setab 0`\n"
    exit
fi