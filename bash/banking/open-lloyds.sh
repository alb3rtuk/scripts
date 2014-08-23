#!/bin/sh
# Opens my Lloyds account.

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-lloyds.rb $displays