#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/sleek/sleek-process-orders.rb $displays