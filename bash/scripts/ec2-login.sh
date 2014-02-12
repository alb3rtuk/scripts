#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

ssh_target="ubuntu@$1"

if [ "${ssh_target}" == "" ]; then
    message red "Error" "SSH Target not specified. Must be an EC2 instance Public DNS address."
    exit
else
    message blue "EC2" "Attempting to log into: \033[33m${ssh_target}\033[0m"
fi

cd ~/.ssh/
ssh ${ssh_target} -i ec2-admin.pem
exit