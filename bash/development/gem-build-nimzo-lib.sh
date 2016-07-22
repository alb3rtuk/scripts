#!/bin/sh

# Builds 'my' ruby gem.

# RubyGem Documentation:
#
# http://guides.rubygems.org/command-reference/#gem-install
#
# -p - Use HTTP proxy for remote operations
# -l - Restrict operations to the LOCAL domain
# -N - Disable documentation generation
# -V - Verbose
# -f - Force gem to install, bypassing dependency checks
# --backtrace -- Show stack backtrace on errors

. ~/Repos/Scripts/bash/common/utilities.sh

sudo cd ~/Repos/nimzo/nimzo-lib/ && cd ~/Repos/nimzo/nimzo-lib/
sudo gem build nimzo-lib.gemspec
sudo gem install ./nimzo-lib-1.2.0.gem --backtrace -V -l