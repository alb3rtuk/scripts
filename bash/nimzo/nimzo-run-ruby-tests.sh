#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo-Ruby/tests/

clear

echo
message magenta "RUBY-RSPEC" "Initializing tests... \033[33m$(date)\033[0m"
echo

rspec