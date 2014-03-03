#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

group=$1

cd ~/Repos/Nimzo/tests-php/

if [[ ${group} == "" ]]; then
    phpunit \
     --bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php \
     --no-configuration \
     --colors \
     --process-isolation \
     /Users/Albert/Repos/Nimzo/tests-php
else
    phpunit \
     --bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php \
     --no-configuration \
     --colors \
     --process-isolation \
     --group ${group} \
     /Users/Albert/Repos/Nimzo/tests-php
fi