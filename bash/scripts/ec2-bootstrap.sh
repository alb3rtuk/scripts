#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

ssh_target=$1
ssh_node_name=$2

ssh_username=${3:-"alb3rtuk"}
ssh_password=${4:-"lkqhacyp52"}
ssh_port=${5:-"22"}

cd ~/Repos/Chef/

if [ "${ssh_target}" == "" ] || [ "${ssh_node_name}" == "" ]; then
    message red "Error" "SSH Target not specified. Must be an EC2 instance Public DNS address."
    exit
else
    message blue "CHEF" "Attempting to bootstrap node at: \033[33m${ssh_target}\033[0m using name: \033[32m${ssh_node_name}\033[0m"
fi

knife bootstrap ${ssh_target} -i ~/.ssh/ec2-admin.pem -x ubuntu --sudo -N "${ssh_node_name}" -p ${ssh_port}
exit