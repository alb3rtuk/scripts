#!/bin/sh

files=0

for file in ~/.Trash/*
do
    if [ "$file" != "/Users/Albert/.Trash/*" ]; then
        files=`expr $files + 1`
        echo "`tput setaf 1`$file`tput setaf 7`"
    fi
done

if [ "$files" -le "0" ]; then
    echo "Nothing to delete. Trash is already empty."
    exit
fi

read -p "You are about to `tput setab 1` permanently delete `tput setab 0` all files in the trash folder. Are you sure you want to continue? [y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    sudo rm -rf ~/.Trash/*
    echo "\nTrash emptied."
else
    echo "\nAborted."
fi

