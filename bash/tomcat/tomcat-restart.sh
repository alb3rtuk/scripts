#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message blue "APACHE TOMCAT" "Restarting Tomcat server.."
echo

cd /Library/Tomcat/bin
./shutdown.sh
echo
./startup.sh
echo