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

ec2_instance_id=$(knife node show ${node_name} -a ec2.instance_id 2>&1)
ec2_instance_id=${ec2_instance_id##*: }

ec2_public_ipv4=$(knife node show ${node_name} -a ec2.public_ipv4 2>&1)
ec2_public_ipv4=${ec2_public_ipv4##*: }

knife node run_list add ${node_name} apt apache2

ssh -i ${pem_file} ${ssh_user}@${ec2_public_ipv4}

exit