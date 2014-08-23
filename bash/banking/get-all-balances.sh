#!/bin/sh
# Shows an overview of all my bank balances.

. ~/Repos/Scripts/bash/common/utilities.sh

clearTerminal

ruby ~/Repos/Scripts/ruby/banking/get-all-balances.rb $1