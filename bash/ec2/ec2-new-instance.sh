#!/bin/sh

. ~/Repos/Scripts/bash/common/ec2.sh

region=$1
initializeRegion

groups="default"
ami="ami-480bea3f"
flavor="t1.micro"
ssh_user="ubuntu"

cd ~/Repos/Chef/

knife ec2 server create \
  --groups=${groups} \
  --region=${region} \
  --image=${ami} \
  --flavor=${flavor} \
  --ssh-user=${ssh_user} \
  --ssh-key=${ssh_key} \
  --identity-file=${pem_file}

echo "Done"