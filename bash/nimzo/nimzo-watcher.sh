#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

clearTerminal

echo "" > /tmp/nimzo-watcher-log.txt

cd ~/Repos/Scripts/bash/nimzo

watch -n 1 ./nimzo-watcher-script.sh

#lessc httpdocs/public/dev/lib/less/app.less > httpdocs/public/min/lib/css/app.min.css -x
#lessc httpdocs/public/dev/lib/less/app.less > httpdocs/public/min/lib/css/app.min.css
#
#java -jar /Users/Albert/Bin/exec/yuicompressor-2.4.8.jar ~/Repos/Nimzo/httpdocs/public/dev/lib/js/jsTools.js -o ~/Repos/Nimzo/httpdocs/public/min/lib/js/jsTools.min.js