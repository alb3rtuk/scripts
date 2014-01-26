#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/get-lloyds-balances.rb $displays $1
exit