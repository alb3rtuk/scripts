#!/usr/bin/env bash

cd ~/Repos/nimzo-ruby/assets/ebay/

# http://stackoverflow.com/questions/1224766/how-do-i-rename-the-extension-for-a-batch-of-files

for file in *.txt; do
    echo ${file}
    mv "$file" "`basename ${file} .txt`.xml"
done