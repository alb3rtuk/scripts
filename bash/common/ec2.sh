#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

getRegions() {
    ec2_regions=("ap-northeast-1" "ap-southeast-1" "eu-west-1" "sa-east-1" "us-east-1"  "us-west-1" "us-west-2")
}

validateRegion() {
    if [[ -z $region ]]; then
        message red "ERROR" "\$region variable must be set before calling \033[33mvalidateRegion()\033[0m."
        exit
    fi
    getRegions
    match=0
    for i in "${ec2_regions[@]}"
    do :
        if [[ ${i} == ${region} ]]; then
            match=1
        fi
    done
    if [[ ${region} == "" ]] || [[ $match == 0 ]]; then
        message red "NO REGION" "You must specify a region. Allowed values are:"
        for i in "${ec2_regions[@]}"
        do :
            echo ${i}
        done
        exit
    fi
}
