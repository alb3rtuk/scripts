#!/bin/sh
# Opens my Lloyds account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/selenium/open-lloyds.rb $displays