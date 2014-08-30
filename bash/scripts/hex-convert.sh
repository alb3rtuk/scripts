#!/bin/sh
# Convert a symbol (IE: →) to hex-code for use in ruby.#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

if [[ $1 == "" ]]; then
    echo
    message red "ERROR" "You must specify a symbol to convert (IE: → )"
    echo
    exit
fi

# Get HEX
CODE=$(echo -n $1 | hexdump)

# Remove Prefix
PREFIX="0000000 2d 6e 20 "
CODE=`echo ${CODE} | sed "s/^${PREFIX}//"`

# Remove everything after => ' 0a 0'
CODE=${CODE% 0a 0*}

echo "\\\x${CODE// /\\\x}"