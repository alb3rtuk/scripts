#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

detectDisplays

ruby ~/Repos/scripts/ruby/sleek/sleek-iconsign-fix.rb $displays

clear
#cat /tmp/iconsign-fix.txt

open -a textedit /tmp/iconsign-fix.txt
# open -a textedit /tmp/iconsign-sent-consignments.txt