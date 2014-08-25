#!/bin/sh
# Opens my BarclayCard account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/selenium/open-barclaycard.rb $displays