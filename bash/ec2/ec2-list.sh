#!/bin/sh
# Lists all currently active EC2 instances.

. ~/Repos/scripts/bash/common/ec2.sh

region=$1

cd ~/Repos/Chef/

getRegions

if [[ $region == "" ]]; then
    message blue "EC2" "Fetching all \033[32mLIVE EC2\033[0m instances"
    echo
    for i in "${ec2_regions[@]}"
    do :
        echo "\033[35m[\033[0m\033[33m${i}\033[0m\033[35m]\033[0m"
        knife ec2 server list --region=${i}
        echo
    done
else
    initializeRegion
    message blue "EC2" "Fetching all \033[32mLIVE EC2\033[0m instances in \033[35m[\033[0m\033[33m${region}\033[0m\033[35m]\033[0m"
    echo
    knife ec2 server list --region=${region}
fi

exit