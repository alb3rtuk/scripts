#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

lastScriptRun=$(date +"%T %Z")

echo "Tailing /tmp/php.out : ${lastScriptRun}"
echo

cat /tmp/php.out