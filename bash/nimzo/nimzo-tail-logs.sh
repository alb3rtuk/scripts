#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

clearTerminal

cd ~/Repos/Scripts/bash/nimzo

# Clear log file.
echo "" > /tmp/php.out

# Start script.
watch -n 1 ./nimzo-tail-logs-script.sh