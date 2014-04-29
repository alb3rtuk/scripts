#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

clearTerminal

cd ~/Repos/Scripts/bash/nimzo

# Run on load.
./nimzo-update.sh

# Clear log file.
echo "" > /tmp/nimzo-watcher-log.txt

# Start script.
watch -n 1 ./nimzo-watcher-script.sh