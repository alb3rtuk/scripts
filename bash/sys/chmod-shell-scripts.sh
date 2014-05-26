#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

# Finds all bash scripts within ~/Repos/Scripts/ (files ending in .sh) and
# CHMOD's them to u+x to make them executable.

echo
cd ~/Repos/Scripts/bash
find . -type f -name "*.sh" -exec echo "chmod 0755 {}" \; -exec chmod 0755 {} \;
cd ~/Repos/Nimzo-Ruby/scripts/nimzo
find . -type f -name "*.sh" -exec echo "chmod 0755 {}" \; -exec chmod 0755 {} \;
echo
message green "SUCCESS" "All shell scripts have been chmod'ed to 0755"
echo