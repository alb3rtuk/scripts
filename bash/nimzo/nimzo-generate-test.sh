#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

# Script to kick-off my Nimzo test (boiler plate) generator for Sleek.

tmpfile="/tmp/phpunit-test.php"

cd ~/Repos/Nimzo/

if [[ ! -f ${tmpfile} ]]; then
    touch ${tmpfile}
fi

file=$1
if [[ ${file} == "" ]]; then
    echo
    message red "ERROR" "You must specify a \033[35m'sleek classname'\033[0m. Valid parameters are:"
    echo
    echo "        \033[33mSleekDiv\033[0m"
    echo "        \033[33mSleekDiv.php\033[0m"
    echo
    exit
fi

# Do some quick validation in Ruby..
output=$(ruby ~/Repos/Scripts/ruby/nimzo/nimzo-generate-test.rb ${file})

# If Ruby doesn't return an exit code of 0 (IE: full steam ahead), abandon ship!
if [[ ! -f ${output} ]]; then
    ruby ~/Repos/Scripts/ruby/nimzo/nimzo-generate-test.rb ${file}
    exit
fi

# Remove PATH-TO-REPO
find="/Users/Albert/Repos/Nimzo/httpdocs/"
replace=""
output=${output//${find}/${replace}}

# If the Ruby validation passes, continue to PHP.
cd ~/Repos/Nimzo/tests-php/bin
echo
message magenta "SLEEK" "Generating PHPUnit Test for: \033[33m${output}\033[0m"
echo
php -f PHPUnit_TestGenerator.php ${output}

# Open the generated file in PHPStorm
open -a phpstorm ${tmpfile}