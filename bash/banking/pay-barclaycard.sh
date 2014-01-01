#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

clear

message red "Pay BarclayCard"

ruby ~/Repos/Scripts/ruby/banking/pay-barclaycard.rb

exit

ruby ~/Repos/Scripts/ruby/banking/pay-barclaycard.rb ydHyu8kdjZl12wAq==

payCreditCard "NatWest Advantage Gold" "Halifax Reward"

if [ "$account" != "0" ] && [ "$amount" != "0" ]; then

    echo "YAY!"

fi