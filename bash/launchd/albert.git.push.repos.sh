#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/Nimzo/
git push

cd ~/Repos/Nimzo-legacy/
git push

cd ~/Repos/Scripts/
git push

cd ~/Repos/Sleek/
git push

logCron "Launchd job: 'albert.git.push.repos' ran successfully. All repos pushed to git."

exit