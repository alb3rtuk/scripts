#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

# GET EC2 REGIONS IN ARRAY
getRegions() {
    ec2_regions=("ap-northeast-1" "ap-southeast-1" "eu-west-1" "sa-east-1" "us-east-1"  "us-west-1" "us-west-2")
}

# VALIDATES IF REGION SUPPLIED BY USER IS VALID AND IF SO, SETS ALL PARAMETERS SUCH AS SSH_KEY, PEM FILES, ETC.
initializeRegion() {
    getRegions
    match=0
    for i in "${ec2_regions[@]}"
    do :
        if [[ ${i} == ${region} ]]; then
            match=1
        fi
    done
    if [[ ${region} == "" ]] || [[ $match == 0 ]]; then
        message red "INVALID REGION" "You must specify a region. Allowed values are:"
        for i in "${ec2_regions[@]}"
        do :
            echo ${i}
        done
        exit
    fi

    if [[ ${region} == "eu-west-1" ]]; then
        ssh_key="ec2-admin-eu-ireland"
        pem_file="~/.ssh/ec2-admin-eu-ireland.pem"
    else
        message red "ERROR" "The region: \033[33m${region}\033[0m has not yet been defined in \033[33minitializeRegion()\033[0m"
        exit
    fi
}
