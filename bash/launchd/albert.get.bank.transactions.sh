#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

logCron "Attempting to get bank transactions.."

ruby ~/Repos/scripts/ruby/launchd/albert.get.bank.transactions.rb