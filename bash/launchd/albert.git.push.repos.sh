#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

logCron "Attempting to push Git repos."

cd ~/Repos/Nimzo/
git push > /dev/null 2>&1

cd ~/Repos/Scripts/
git push > /dev/null 2>&1

cd ~/Repos/Sleek/
git push > /dev/null 2>&1

logCron "Successfully pushed Git repos."

exit