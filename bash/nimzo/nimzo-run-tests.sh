#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo/tests-php/

clear

echo
message magenta " PHPUNIT " "Initializing tests... \033[33m$(date +"%a %e %b %Y %H:%M:%S")\033[0m"
echo

phpunit \
--bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php \
--no-configuration \
--colors \
/Users/Albert/Repos/Nimzo/tests-php

ruby ~/Repos/Nimzo-Ruby/tests/TestRunner.rb false
echo