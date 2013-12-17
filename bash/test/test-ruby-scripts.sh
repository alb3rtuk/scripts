#!/bin/sh

# Runs all ruby tests in ~/Repos/Scripts/ruby/tests/.

input=$1

if [ "$input" != '' ]; then
    echo "Running: \x1B[92m$input\x1B[0m"
    ruby $input
else
    cd ~/Repos/Scripts/ruby/tests/
    for i in $(find . -type f -name "*.rb"); do
        echo "Running: \x1B[92m$i\x1B[0m"
        ruby $i
    done
fi