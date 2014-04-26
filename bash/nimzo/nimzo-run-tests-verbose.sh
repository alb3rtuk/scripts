#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

group=$1

cd ~/Repos/Nimzo/tests-php/

echo
message magenta "PHPUNIT" "Initializing tests..."
echo

if [[ ${group} == "" ]]; then
    phpunit \
     --bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php \
     --no-configuration \
     --colors \
     /Users/Albert/Repos/Nimzo/tests-php \
     -- verbose
else
    phpunit \
     --bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php \
     --no-configuration \
     --colors \
     --group ${group} \
     /Users/Albert/Repos/Nimzo/tests-php
     -- verbose
fi