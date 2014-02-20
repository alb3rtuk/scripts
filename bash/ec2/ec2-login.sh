#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/common/ec2.sh

cd ~/Repos/Chef/

region=$1
initializeRegion

ssh_target=$2
validateSSHTarget

ssh -i ${pem_file} ${ssh_user}@${ssh_target}