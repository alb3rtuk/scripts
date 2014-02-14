#!/bin/sh

. ~/Repos/Scripts/bash/common/ec2.sh

node_id=$1

if [[ $node_id == "" ]]; then
    message red "ERROR" "Node ID (1st parameter) was not specified. "
    exit
fi

cd ~/Repos/Chef/

knife node delete ${node_id}

message green "SUCCESS" "Chef node with ID: \033[33m${node_id}\033[0m was removed."

exit