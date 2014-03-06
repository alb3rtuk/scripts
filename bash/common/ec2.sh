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
        message red "ERROR" "You must specify a region (1st parameter). Valid regions are:"
        for i in "${ec2_regions[@]}"
        do :
            echo "\033[33m${i}\033[0m"
        done
        exit
    fi
    if [[ ${region} == "eu-west-1" ]]; then
        ssh_user="ubuntu"
        ssh_key="ec2-eu-west-1"
        pem_file="/Users/Albert/.ssh/ec2-eu-west-1.pem"
        image="ami-480bea3f" # Ubuntu Server 13.10       / 64-bit
      # image="ami-8e987ef9" # Ubuntu Server 12.04.3 LTS / 64-bit
        flavor="t1.micro"
        ebs_size="8"
        groups="default"
    elif [[ ${region} == "us-west-1" ]]; then
        ssh_user="ubuntu"
        ssh_key="ec2-us-west-1"
        pem_file="/Users/Albert/.ssh/ec2-us-west-1.pem"
        image="ami-4843740d"
        flavor="t1.micro"
        ebs_size="8"
        groups="default"
    elif [[ ${region} == "us-west-2" ]]; then
        ssh_user="ubuntu"
        ssh_key="ec2-us-west-2"
        pem_file="/Users/Albert/.ssh/ec2-us-west-2.pem"
        image="ami-ace67f9c" # Ubuntu Server 13.10       / 64-bit
        flavor="t1.micro"
        ebs_size="8"
        groups="default"
    else
        message red "ERROR" "The region: \033[33m${region}\033[0m has not yet been defined in \033[33minitializeRegion()\033[0m"
        exit
    fi
}

validateNodeName() {
    if [[ ${node_name} == "" ]]; then
        message red "ERROR" "You must specify a node name (2nd parameter)."
        exit
    fi
}


validateSSHTarget() {
    if [[ ${ssh_target} == "" ]]; then
        message red "ERROR" "You must specify an SSH target (2nd parameter)."
        exit
    fi
}