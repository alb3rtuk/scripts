#!/bin/sh

if [ "$1" == "" ]; then
    message red "Error" "SSH Target not specified. Must be an EC2 instance Public DNS address."
    exit
else
    message blue "EC2" "Attempting to log into: \033[33m$1\033[0m"
fi

ssh_target="ubuntu@$1"

cd ~/.ssh/