#!/bin/sh

files=(~/Repos/scripts/ruby/gumtree/*)

for ((i=0; i<${#files[@]}; i++)); do
    /Users/Natalee/.rvm/wrappers/gumtree/ruby ${files[$i]}
done