#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

echo
message red "APACHE TOMCAT" "Shutting down Tomcat server.."
echo

cd /Library/Tomcat/bin
./shutdown.sh
echo