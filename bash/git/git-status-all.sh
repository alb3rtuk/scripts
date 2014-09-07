#!/bin/sh
# Gets the status of all my Git repos.

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message magenta " GIT " "Getting status of all repos... \033[33m$(date +"%a %e %b %Y %H:%M:%S")\033[0m"
echo

echo "\033[35m~/Repos/chef/\033[0m"
cd ~/Repos/Chef/
git status

echo "\033[35m~/Repos/scripts/\033[0m"
cd ~/Repos/Scripts/
git status

echo "\033[35m~/Repos/nimzo-java/\033[0m"
cd ~/Repos/nimzo-java/
git status

echo "\033[35m~/Repos/nimzo-legacy/\033[0m"
cd ~/Repos/nimzo-legacy/
git status

echo "\033[35m~/Repos/nimzo-php/\033[0m"
cd ~/Repos/nimzo-php/
git status

echo "\033[35m~/Repos/nimzo-ruby/\033[0m"
cd ~/Repos/nimzo-ruby/
git status

echo