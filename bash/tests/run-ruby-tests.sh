#!/bin/sh

# Runs all ruby tests in ~/Repos/Scripts/ruby/tests/.

. ~/Repos/Scripts/bash/common/common-utilities.sh

input=$1

if [ "$input" != '' ]; then
    echo
    message green "Running" "$input"
    echo
    ruby $input
    echo
else
    cd ~/Repos/Scripts/ruby/tests/
    for input in $(find . -type f -name "*.rb"); do
        echo
        message green "Running" "$input"
        echo
        ruby $input
    done
fi