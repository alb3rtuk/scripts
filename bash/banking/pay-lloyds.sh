#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/banking/pay-lloyds.rb $displays