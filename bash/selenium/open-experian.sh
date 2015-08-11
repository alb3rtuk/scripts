#!/bin/sh
# Opens my Experian account.

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/open-experian.rb $displays