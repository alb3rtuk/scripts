#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message blue "APACHE TOMCAT" "Shutting down Tomcat server.."
echo

cd /Library/Tomcat/bin
./shutdown.sh
echo