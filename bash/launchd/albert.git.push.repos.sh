#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Chef/
git push > /dev/null 2>&1

cd ~/Repos/Raillercoaster/
git push > /dev/null 2>&1

cd ~/Repos/Scripts/
git push > /dev/null 2>&1

cd ~/Repos/brooklins-legacy/
git push > /dev/null 2>&1

cd ~/Repos/eBay/
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

cd ~/Repos/sleek/
git push > /dev/null 2>&1

cd ~/Repos/sleek-furniture/
git push > /dev/null 2>&1

exit