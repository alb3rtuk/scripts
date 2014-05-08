#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message blue "APACHE TOMCAT" "Starting Tomcat server.."
echo

cd /Library/Tomcat/bin
./startup.sh
echo