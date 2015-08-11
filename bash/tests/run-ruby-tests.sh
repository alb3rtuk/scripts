#!/bin/sh

# Runs all ruby tests in ~/Repos/scripts/ruby/tests/.

. ~/Repos/scripts/bash/common/utilities.sh

input=$1

if [ "$input" != '' ]; then
    echo
    message green "Running" "$input"
    echo
    ruby $input
    echo
else
    cd ~/Repos/scripts/ruby/tests/
    for input in $(find . -type f -name "*.rb"); do
        echo
        message green "Running" "$input"
        echo
        ruby $input
    done
fi