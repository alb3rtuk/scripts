#!/bin/sh
# Opens my Halifax account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/selenium/open-halifax.rb $displays