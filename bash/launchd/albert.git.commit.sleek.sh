#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

# Automatically commits to Sleek (documentation) repo every 24 hours.
# The core files are duplicated within the Nimzo repo anyway but it's always good to have a backup.

cd ~/Repos/Sleek/

# Checks if changes have been made in Git.
if git diff-index --quiet HEAD --; then

    # NO CHANGES
    exit

else

    # CHANGES
    commitMessage="$(date) | Sleek auto-commit."
    git add . -A
    git commit -m "${commitMessage}"
    git push > /dev/null 2>&1
    exit

fi
