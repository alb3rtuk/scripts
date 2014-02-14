#!/bin/sh

. ~/Repos/Scripts/bash/common/ec2.sh

getRegions

cd ~/Repos/Chef/

clear

message blue "EC2" "Fetching all \033[32mLIVE EC2 instances\033[0m."

echo

for i in "${ec2_regions[@]}"
do :
    echo "\033[35m[\033[0m\033[33m${i}\033[0m\033[35m]\033[0m"
    knife ec2 server list --region=${i}
    echo
done

exit