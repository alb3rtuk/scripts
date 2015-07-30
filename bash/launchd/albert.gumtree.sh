#!/bin/sh

files=(~/Repos/scripts/ruby/gumtree/*)

for ((i=0; i<${#files[@]}; i++)); do
    # http://notes.jerzygangi.com/creating-a-ruby-launchd-task-with-rvm-in-os-x/
    ruby ${files[$i]}
done

exit