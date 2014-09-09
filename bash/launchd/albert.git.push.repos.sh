#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/brightpearl-scripts/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-java/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-legacy/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-php/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-php-docs/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-ruby/
git push > /dev/null 2>&1

cd ~/Repos/scripts/
git push > /dev/null 2>&1

exit