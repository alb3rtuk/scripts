#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

clear

detectDisplays

message red "Pay CapitalOne Platinum VISA"

ruby ~/Repos/Scripts/ruby/banking/pay-capitalone.rb $displays $1