#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

# Gets the octal value of a file (IE: 0755)

file=$1
if [[ ${file} == "" ]]; then
    message red "ERROR" "You must provide a filename."
    exit
fi
stat -f %Mp%Lp ${file}