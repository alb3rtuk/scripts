#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

logCron "Attempting to get bank transactions.."

ruby ~/Repos/Scripts/ruby/launchd/albert.get.bank.transactions.rb