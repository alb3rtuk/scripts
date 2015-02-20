#!/bin/sh
# Gets the status of all my Git repos.

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message magenta " GIT " "Getting status of all repos... \033[33m$(date +"%a %e %b %Y %H:%M:%S")\033[0m"
echo

echo "\033[35m~/Repos/columnist/\033[0m"
cd ~/Repos/columnist/
git status

echo "\033[35m~/Repos/brightpearl-cli/\033[0m"
cd ~/Repos/brightpearl-cli/
git status

echo "\033[35m~/Repos/convoy/\033[0m"
cd ~/Repos/convoy/
git status

echo "\033[35m~/Repos/nimzo-java/\033[0m"
cd ~/Repos/nimzo-java/
git status

echo "\033[35m~/Repos/nimzo-node/\033[0m"
cd ~/Repos/nimzo-node/
git status

echo "\033[35m~/Repos/nimzo-php/\033[0m"
cd ~/Repos/nimzo-php/
git status

echo "\033[35m~/Repos/nimzo-ruby/\033[0m"
cd ~/Repos/nimzo-ruby/
git status

echo "\033[35m~/Repos/scripts/\033[0m"
cd ~/Repos/scripts/
git status

echo "\033[35m~/Repos/sql-backups/\033[0m"
cd ~/Repos/sql-backups/
git status

echo