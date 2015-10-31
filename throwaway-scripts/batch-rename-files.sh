#!/usr/bin/env bash

cd ~/Repos/nimzo-java/nimzo-lib/src/main/resources/assets-test/xml-ebay

# http://stackoverflow.com/questions/1224766/how-do-i-rename-the-extension-for-a-batch-of-files

for file in *.txt.xml; do
    echo ${file}
    mv "$file" "`basename ${file} .txt.xml`.xml"
done