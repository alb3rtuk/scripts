#!/bin/sh
# Opens my Capital One account.

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/open-capitalone.rb $displays