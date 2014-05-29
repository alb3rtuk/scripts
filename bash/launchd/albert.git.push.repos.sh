#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/nimzo-php/
git push > /dev/null 2>&1

cd ~/Repos/nimzo-ruby/
git push > /dev/null 2>&1

cd ~/Repos/Nimzo-Java/
git push > /dev/null 2>&1

cd ~/Repos/Scripts/
git push > /dev/null 2>&1

cd ~/Repos/Sleek/
git push > /dev/null 2>&1

exit