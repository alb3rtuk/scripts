#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

clearTerminal

echo
message magenta "LOTTO PREDICTER" " Attempting to predict the next lottery numbers... \033[33m$(date)\033[0m"
echo

ruby ~/Repos/scripts/ruby/scripts/lotto-predicter.rb $1