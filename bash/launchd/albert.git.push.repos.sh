#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

message red " DEPRECATED " "This script is deprecated."
exit

repos=(brightpearl-cli columnist convoy factory-mall finance-report my-cli nimzo-java nimzo-node nimzo-php nimzo-ruby scripts shared)

for i in "${repos[@]}"
do :
    cd ~/Repos/${i}/
    git push > /dev/null 2>&1
done

exit