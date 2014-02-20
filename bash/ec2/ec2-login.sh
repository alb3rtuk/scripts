#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/ec2/common/login.sh

echo ${ssh_target}

ssh  -i ec2-admin-eu-ireland.pem ${ssh_target}