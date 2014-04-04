#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo/
git push > /dev/null 2>&1

cd ~/Repos/Nimzo-legacy/
git push > /dev/null 2>&1

cd ~/Repos/Scripts/
git push > /dev/null 2>&1

cd ~/Repos/Sleek/
git push > /dev/null 2>&1

logCron "Launchd job: 'albert.git.push.repos' ran successfully. All repos pushed to git."

exit