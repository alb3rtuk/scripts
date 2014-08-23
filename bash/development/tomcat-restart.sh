#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message blue "APACHE TOMCAT" "Restarting Tomcat server.."
echo

cd /Library/Tomcat/bin
./shutdown.sh
echo
sleep 2
./startup.sh
echo