#!/bin/sh
# Opens my BarclayCard account.

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/open-barclaycard.rb $displays