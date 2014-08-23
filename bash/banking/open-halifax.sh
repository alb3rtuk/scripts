#!/bin/sh
# Opens my Halifax account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-halifax.rb $displays