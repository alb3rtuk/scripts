#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/Scripts/ruby/sleek/sleek-iconsign-find-non-collected.rb $displays

open -a textedit /tmp/iconsign-never-collected-consignments.txt