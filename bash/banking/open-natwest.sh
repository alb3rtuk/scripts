#!/bin/sh
# Opens my NatWest account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-natwest.rb $displays