#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

# Finds all bash scripts within ~/Repos/scripts/ (files ending in .sh) and
# CHMOD's them to u+x to make them executable.

echo
cd ~/Repos/scripts/bash
find . -type f -name "*.sh" -exec echo "chmod 0755 {}" \; -exec chmod 0755 {} \;
cd ~/Repos/nimzo-ruby/scripts/nimzo
find . -type f -name "*.sh" -exec echo "chmod 0755 {}" \; -exec chmod 0755 {} \;
echo
message green "SUCCESS" "All shell scripts have been chmod'ed to 0755"