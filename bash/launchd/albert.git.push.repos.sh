#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/columnist/
git push > /dev/null 2>&1

cd ~/Repos/convoy/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-java/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-node/
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