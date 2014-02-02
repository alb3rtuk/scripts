#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-experian.rb $displays