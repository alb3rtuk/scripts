#!/bin/sh
# Updates all bank transactions/balances in DB.

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/get-bank-transactions.rb ${displays} $1