#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo/
git push > /dev/null 2>&1

cd ~/Repos/Nimzo-Ruby/
git push > /dev/null 2>&1

cd ~/Repos/Nimzo-Java/
git push > /dev/null 2>&1

cd ~/Repos/Scripts/
git push > /dev/null 2>&1

cd ~/Repos/Sleek/
git push > /dev/null 2>&1

exit