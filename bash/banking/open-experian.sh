#!/bin/sh
# Opens my Experian account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-experian.rb $displays