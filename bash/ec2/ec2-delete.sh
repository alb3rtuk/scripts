#!/bin/sh

. ~/Repos/Scripts/bash/common/ec2.sh

region=$1
initializeRegion

node_id=$2

if [[ $node_id == "" ]]; then
    message red "ERROR" "Node ID (2nd parameter) was not specified. "
    exit
fi

cd ~/Repos/Chef/

knife ec2 server delete ${node_id} --region ${region} --purge

message green "SUCCESS" "EC2 instance with ID: \033[33m${node_id}\033[0m on \033[33m${region}\033[0m was successfully deleted. All associated Chef node & clients were also removed."

exit