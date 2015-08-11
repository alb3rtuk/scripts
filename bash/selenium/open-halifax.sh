#!/bin/sh
# Opens my Halifax account.

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/open-halifax.rb $displays