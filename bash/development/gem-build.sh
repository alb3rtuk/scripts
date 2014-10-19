#!/bin/sh

# Build the 'brightpearl-cli' ruby gem.

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/brightpearl-cli/

sudo gem build brightpearl-cli.gemspec
sudo gem install brightpearl-cli-1.0.0.gem