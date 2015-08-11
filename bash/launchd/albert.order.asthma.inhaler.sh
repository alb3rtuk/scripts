#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

logCron "Attempting to order asthma inhalers from Nevil Road Surgery website."

ruby ~/Repos/scripts/ruby/launchd/albert.order.asthma.inhaler.rb