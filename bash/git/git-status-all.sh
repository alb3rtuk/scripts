#!/bin/sh
# Gets the status of all my Git repos.

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message magenta " GIT " "Getting status of all repos... \033[33m$(date +"%a %e %b %Y %H:%M:%S")\033[0m"
echo


echo "\033[35m~/Repos/Chef/\033[0m"
cd ~/Repos/Chef/
git status

echo "\033[35m~/Repos/Raillercoaster/\033[0m"
cd ~/Repos/Raillercoaster/
git status

echo "\033[35m~/Repos/Scripts/\033[0m"
cd ~/Repos/Scripts/
git status

echo "\033[35m~/Repos/brooklins-legacy/\033[0m"
cd ~/Repos/brooklins-legacy/
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

echo "\033[35m~/Repos/sleek/\033[0m"
cd ~/Repos/sleek/
git status

echo "\033[35m~/Repos/sleek-furniture/\033[0m"
cd ~/Repos/sleek-furniture/
git status

echo

exit