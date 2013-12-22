#!/bin/sh

# Runs all ruby tests in ~/Repos/Scripts/ruby/tests/.

. ~/Repos/Scripts/bash/common/common-utilities.sh

input=$1

if [ "$input" != '' ]; then
    message green "Running" "$input"
    ruby $input
else
    cd ~/Repos/Scripts/ruby/tests/
    for input in $(find . -type f -name "*.rb"); do
        message green "Running" "$input"
        ruby $input
    done
fi