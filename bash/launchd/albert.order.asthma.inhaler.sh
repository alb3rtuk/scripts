#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

logCron "Attempting to order asthma inhalers from Nevil Road Surgery website."

ruby ~/Repos/Scripts/ruby/launchd/albert.order.asthma.inhaler.rb