#!/bin/sh
# Opens my Lloyds account.

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/open-lloyds.rb $displays