#!/bin/sh
# Shows an overview of all my bank transactions & balances.

. ~/Repos/Scripts/bash/common/utilities.sh

clearTerminal

ruby ~/Repos/Scripts/ruby/show/show-bank-transactions.rb $1