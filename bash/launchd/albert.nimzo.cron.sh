#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

logCron "Launchd job: 'albert.nimzo.cron' started."

ruby ~/Repos/Scripts/ruby/launchd/albert.nimzo.cron.rb
exit
