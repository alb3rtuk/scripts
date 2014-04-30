#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

group=$1

cd ~/Repos/Nimzo/tests-php/

clear

echo
message magenta "PHPUNIT" "Initializing tests... \033[33m$(date)\033[0m"
echo

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