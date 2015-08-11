#!/bin/sh
# Opens my NatWest account.

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/open-natwest.rb $displays