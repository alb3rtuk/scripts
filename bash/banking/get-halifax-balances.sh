#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/get-halifax-balances.rb $displays $1
exit