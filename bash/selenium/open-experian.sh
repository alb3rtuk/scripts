#!/bin/sh
# Opens my Experian account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/selenium/open-experian.rb $displays