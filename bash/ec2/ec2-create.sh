#!/bin/sh

. ~/Repos/Scripts/bash/common/ec2.sh

region=$1
initializeRegion

node_name=$2

groups="default"
flavor="t1.micro"
ssh_user="ubuntu"
size="10"

cd ~/Repos/Chef/

knife ec2 server create \
  --node-name="${node_name}" \
  --groups=${groups} \
  --region=${region} \
  --image=${ami} \
  --flavor=${flavor} \
  --ssh-user=${ssh_user} \
  --ssh-key=${ssh_key} \
  --identity-file=${pem_file} \
  --ebs-size ${size} \
  --ebs-no-delete-on-term

exit