#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

fromDirectory=$1
toDirectory=$2

if [[ ${fromDirectory} == "" ]] || [[ ${toDirectory} == "" ]]; then
    echo
    message red "ERROR" "Must specify 'from' directory \033[33m(parameter 1)\033[0m and 'to' directory \033[33m(parameter 2)\033[0m. NO TRAILING SLASHES!"
    echo
    exit
fi

if [[ ! -d ${fromDirectory} ]]; then
    echo
    message red "ERROR" "\033[33m${fromDirectory}\033[0m is not a valid directory."
    echo
    exit
fi

if [[ ! -d ${toDirectory} ]]; then
    echo
    message red "ERROR" "\033[33m${toDirectory}\033[0m is not a valid directory."
    echo
    exit
fi

echo
message magenta "SYMLINK" "Sym-linking all files from \033[33m${fromDirectory}\033[0m to \033[33m${toDirectory}\033[0m."
for f in $(ls -d ${fromDirectory}/*); do sudo ln -s ${f} ${toDirectory}; done
echo