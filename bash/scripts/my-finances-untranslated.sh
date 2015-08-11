#!/bin/sh
# Shows an overview of all my bank transactions & balances.

. ~/Repos/scripts/bash/common/utilities.sh

clearTerminal

echo
message magenta "MY FINANCES" " Generating report (with untranslated transactions)... \033[33m$(date)\033[0m"
echo

ruby ~/Repos/scripts/ruby/scripts/my-finances.rb 'untranslated'