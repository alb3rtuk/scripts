#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

repos=(brightpearl-cli columnist convoy nimzo-java nimzo-node nimzo-php nimzo-php-docs nimzo-ruby scripts shared)

for i in "${repos[@]}"
do :
    cd ~/Repos/${i}/
    git push > /dev/null 2>&1
done

exit