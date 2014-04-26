#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

clearTerminal

./nimzo-update.sh

echo "" > /tmp/nimzo-watcher-log.txt
cd ~/Repos/Scripts/bash/nimzo
watch -n 1 ./nimzo-watcher-script.sh