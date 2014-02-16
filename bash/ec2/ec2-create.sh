#!/bin/sh

. ~/Repos/Scripts/bash/common/ec2.sh

cd ~/Repos/Chef/

region=$1
initializeRegion

node_name=$2
validateNodeName

knife ec2 server create \
  --node-name="${node_name}" \
  --groups=${groups} \
  --region=${region} \
  --image=${image} \
  --flavor=${flavor} \
  --ssh-user=${ssh_user} \
  --ssh-key=${ssh_key} \
  --identity-file=${pem_file} \
  --ebs-size ${ebs_size} \

exit