#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/sleek/sleek-process-orders.rb $displays