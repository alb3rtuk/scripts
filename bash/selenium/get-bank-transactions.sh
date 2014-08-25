#!/bin/sh
# Updates all bank transactions/balances in DB.

. ~/Repos/Scripts/bash/common/utilities.sh

# clearTerminal

ruby ~/Repos/Scripts/ruby/selenium/get-bank-transactions.rb true