#!/bin/sh

input=$1

echo "$input"

clear

if [ "$input" != '' ]; then

    echo -e "Running: \x1B[92m $input\x1B[0m"
    ruby $input

else

    cd ~/Repos/Scripts/ruby/tests/
    for i in $(find . -type f -name "*.rb"); do
        echo -e "Running: \x1B[92m $i\x1B[0m"
        ruby $i
    done

fi