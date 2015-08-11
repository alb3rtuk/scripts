#!/bin/sh

# Displays a list of ALL terminal colors.
# Additional scripts can be found at: http://misc.flogisoft.com/bash/tip_colors_and_formatting

. ~/Repos/scripts/bash/common/utilities.sh

for fgbg in 38 48 ; do
    echo
    message green "BASH" "\\\033[${fgbg};5;\033[33mXXX\033[0mm to set \xe2\x80\x94 \\\033[0m to reset"
    message red "RUBY" "\\\x1B[${fgbg};5;\033[33mXXX\033[0mm to set \xe2\x80\x94 \\\x1B[0m to reset"
    echo
	for color in {0..256} ; do
		printf "\033[${fgbg};5;${color}m ${color}\t\033[0m"
		if [ $((($color + 1) % 16)) == 0 ] ; then
			echo
		fi
	done
	echo
done

exit