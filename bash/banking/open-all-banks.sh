#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/open-all-banks.rb $displays