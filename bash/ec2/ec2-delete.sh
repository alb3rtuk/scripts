#!/bin/sh
# Deletes a EC2 instance and disassociates it with Chef.

. ~/Repos/scripts/bash/common/ec2.sh

region=$1
initializeRegion

node_id=$2

if [[ $node_id == "" ]]; then
    message red "ERROR" "Node ID (2nd parameter) was not specified. "
    exit
fi

cd ~/Repos/Chef/

knife ec2 server delete ${node_id} --region ${region} --purge

exit