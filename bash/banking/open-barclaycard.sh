#!/bin/sh
# Opens my BarclayCard account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-barclaycard.rb $displays