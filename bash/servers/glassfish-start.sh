#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

echo
message blue "GLASSFISH" "Starting glassfish server (http://localhost:4848).."
echo

cd /Library/Glassfish/bin
./asadmin start-domain
echo