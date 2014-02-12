#!/bin/sh

# Finds all bash scripts within ~/Repos/Scripts/ (files ending in .sh) and
# CHMOD's them to u+x to make them executable.

cd ~/Repos/Scripts/bash
find . -type f -name *.sh -exec echo "chmod 0755 {}" \; -exec chmod 0755 {} \;
message green "SUCCESS" "All shell scripts within ~/Repos/Scripts/bash/ have been chmod'ed to 0755"
