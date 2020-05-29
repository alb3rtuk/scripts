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

cd ~/Repos/my
gem build my.gemspec 2>/dev/null
gem install my-1.0.2.gem --backtrace -V -l