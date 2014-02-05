#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

tmpFile="/tmp/ec2-bash.sh"

message red "UPDATE SLEEK" "Running update-sleek script:"

# CREATE LOCAL BASH SCRIPT TO RUN ON AMAZON
touch ${tmpFile}
echo "cd ~/repos/Sleek" >> ${tmpFile}
echo "git pull" >> ${tmpFile}
echo "cd /" >> ${tmpFile}
echo "sudo su" >> ${tmpFile}
echo "rm -rf /var/www" >> ${tmpFile}
echo "cd var" >> ${tmpFile}
echo "mkdir www" >> ${tmpFile}
echo "cd /" >> ${tmpFile}
echo "cp -r /home/ubuntu/repos/Sleek/httpdocs/. /var/www" >> ${tmpFile}
echo "exit" >> ${tmpFile}
echo "cd /var/www" >> ${tmpFile}
echo "ls -la" >> ${tmpFile}

cd ~/Repos/Sleek
pwd=`pwd`
echo "\033[37mSwitching to: $pwd\033[0m"

echo "\033[37mPushing 'Sleek' repo to GitHub\033[0m"
git push

cd ~/.ssh/
pwd=`pwd`
echo "\033[37mSwitching to: $pwd\033[0m"

echo "\033[37mAttempting to SSH into Amazon EC2 instance (ec2-54-201-246-204.us-west-2.compute.amazonaws.com)\033[0m"
ssh -i ec2-admin.pem ubuntu@ec2-54-201-246-204.us-west-2.compute.amazonaws.com 'bash -s' < ${tmpFile}

rm ${tmpFile}



