#!/bin/sh

# Cron which backs up my ~/.bash_profile into the GIT repo where I store all
# my personal bash scripts.
#
# Please note: THIS IS NOT THE .BASH_PROFILE USED BY THE SYSTEM, JUST A BACKUP.

cd ~
cp ~/.bash_profile ~/Repos/Scripts/.bash_profile