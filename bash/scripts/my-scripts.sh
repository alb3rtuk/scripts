#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

clearTerminal

# Use Ruby to compose a temp text file which lists all my bash scripts + their info.
ruby ~/Repos/scripts/ruby/scripts/my-scripts.rb

# Display the temp file in terminal.
cat /tmp/my-scripts-output.txt

# Remove the temporary file.
rm -rf /tmp/my-scripts-output.txt

exit