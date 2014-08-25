#!/bin/sh
# Opens my Capital One account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/selenium/open-capitalone.rb $displays