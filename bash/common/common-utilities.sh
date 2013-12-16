#!/bin/sh

# Checks if a file exists. Exits script if it doesn't.
function verifyFileExists()
{
    file=$1
    if [ ! -f $file ]; then
        echo "`tput setab 1` ERROR: `tput setab 0` The file `tput setaf 3`$file`tput setaf 7` doesn't exist."
        exit
    fi
}