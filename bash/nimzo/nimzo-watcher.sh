#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo/

lessc httpdocs/public/dev/lib/less/app.less > httpdocs/public/min/lib/css/app.min.css -x
lessc httpdocs/public/dev/lib/less/app.less > httpdocs/public/min/lib/css/app.min.css
