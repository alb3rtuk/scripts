#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

group=$1

if [[ ${group} == "" ]]; then
    phpunit \
     --bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php \
     --no-configuration \
     --colors \
     /Users/Albert/Repos/Nimzo/tests-php
else
    phpunit \
     --bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php \
     --no-configuration \
     --colors \
     --group ${group} \
     /Users/Albert/Repos/Nimzo/tests-php
fi