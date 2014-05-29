#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh


cd ~/Repos/nimzo-php/httpdocs/private/lib/sleek/
nimzoSleekPhpLMT=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 1 -d" ")

cd ~/Repos/nimzo-php/httpdocs/public/dev/lib/app-less/sleek/
nimzoSleekDevLMT=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 1 -d" ")

cd ~/Repos/Sleek/httpdocs/
nimzoSleekLMT=$(find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f 1 -d" ")

echo $nimzoSleekPhpLMT
echo $nimzoSleekDevLMT
echo $nimzoSleekLMT

exit