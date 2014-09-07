#!/bin/sh
# Pulls & pushes all my Git repos from/to GitHub.

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message magenta " GIT " "Syncing all repos... \033[33m$(date +"%a %e %b %Y %H:%M:%S")\033[0m"
echo

echo "\033[35m~/Repos/brightpearl-ruby/\033[0m"
cd ~/Repos/brightpearl-ruby/
git pull
git push

echo "\033[35m~/Repos/nimzo-java/\033[0m"
cd ~/Repos/nimzo-java/
git pull
git push

echo "\033[35m~/Repos/nimzo-legacy/\033[0m"
cd ~/Repos/nimzo-legacy/
git pull
git push

echo "\033[35m~/Repos/nimzo-php/\033[0m"
cd ~/Repos/nimzo-php/
git pull
git push

echo "\033[35m~/Repos/nimzo-ruby/\033[0m"
cd ~/Repos/nimzo-ruby/
git pull
git push

echo "\033[35m~/Repos/scripts/\033[0m"
cd ~/Repos/scripts/
git pull
git push

echo