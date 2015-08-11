#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/selenium/open-nevil-road-surgery.rb $displays