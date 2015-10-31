#!/usr/bin/env bash

cd ~/Repos/nimzo-java/nimzo-lib/src/main/resources/assets-test/xml-ebay

for file in *.txt.xml; do
    echo ${file}
    mv "$file" "`basename ${file} .txt.xml`.xml"
done