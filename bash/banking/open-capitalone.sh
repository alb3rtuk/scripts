#!/bin/sh
# Opens my Capital One account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-capitalone.rb $displays