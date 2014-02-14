#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/ec2/common/login.sh

scp -i ec2-admin-eu-ireland.pem ~/Repos/Scripts/bash/ec2/common/first-run.sh ${ssh_target}:/tmp/first-run.sh

tmpFile="/tmp/ec2-bash.sh"

rm ${tmpFile}

touch ${tmpFile}
echo "cd /tmp" >> ${tmpFile}
echo "./first-run.sh" >> ${tmpFile}
echo "rm first-run.sh" >> ${tmpFile}

ssh -i ec2-admin-eu-ireland.pem ${ssh_target} 'bash -s' < ${tmpFile}

rm ${tmpFile}