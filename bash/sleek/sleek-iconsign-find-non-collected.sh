#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/sleek/sleek-iconsign-find-non-collected.rb $displays

open -a textedit /tmp/iconsign-never-collected-consignments.txt