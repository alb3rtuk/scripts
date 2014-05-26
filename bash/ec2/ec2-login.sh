#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/common/ec2.sh

cd ~/Repos/Chef/

#region=$1
#initializeRegion
#
#ssh_target=$2
#validateSSHTarget
#
#ssh -i ${pem_file} ${ssh_user}@${ssh_target}

ssh -i /Users/Albert/.ssh/ec2-eu-west-1.pem ec2-user@ec2-54-76-49-176.eu-west-1.compute.amazonaws.com