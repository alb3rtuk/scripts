#!/bin/sh
# Opens my NatWest account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/selenium/open-natwest.rb $displays