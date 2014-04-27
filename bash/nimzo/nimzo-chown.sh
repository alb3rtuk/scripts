#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

# Immediate fix to all permission issues (usually to do with images).

cd ~/Repos/Nimzo/httpdocs/public/img/
find . -type f -name *.* -exec echo "chmod 0755 {}" \; -exec chmod 0755 {} \;
message green "SUCCESS" "All the above files have been chmod'ed to 0755"