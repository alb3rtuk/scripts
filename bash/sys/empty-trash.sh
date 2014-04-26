#!/bin/sh

files=0

clear
echo

for file in ~/.Trash/*
do
    if [ "$file" != "/Users/Albert/.Trash/*" ]; then
        files=`expr ${files} + 1`
        echo "`tput setaf 1`$file`tput setaf 7`"
    fi
done

if [ "$files" -le "0" ]; then
    echo "\033[0mNothing to delete. Trash is already empty."
    puts
    exit
fi

read -p "`echo "\n\033[0m"`You are about to `tput setab 1` PERMANENTLY DELETE `tput setab 0` all files in the trash folder. Are you sure you want to continue? [y/n] => " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo rm -rf ~/.Trash/*
    echo "Trash emptied.\n"
else
    echo "Script aborted.\n"
fi