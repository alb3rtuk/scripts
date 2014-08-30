#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

clearTerminal

echo
message magenta "LOTTO PREDICTER" " Attempting to predict the next lottery numbers... \033[33m$(date)\033[0m"
echo

ruby ~/Repos/Scripts/ruby/scripts/lotto-predicter.rb