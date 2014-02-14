#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/ec2/common/login.sh

scp -i ec2-admin-eu-ireland.pem ~/Repos/Scripts/bash/ec2/common/first-run.sh ${ssh_target}:/tmp/first-run.sh
scp -i ec2-admin-eu-ireland.pem ~/Repos/Scripts/bash/ec2/common/.gitconfig ${ssh_target}:~/.gitconfig

tmpFile="/tmp/ec2-bash.sh"

if [ -f ${tmpFile} ]; then
    rm ${tmpFile}
fi

touch ${tmpFile}
echo "cd /tmp" >> ${tmpFile}
echo "./first-run.sh" >> ${tmpFile}
echo "rm first-run.sh" >> ${tmpFile}

ssh -i ec2-admin-eu-ireland.pem ${ssh_target} 'bash -s' < ${tmpFile}

rm ${tmpFile}