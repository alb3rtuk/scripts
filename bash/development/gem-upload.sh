#!/bin/sh

# Upload the 'brightpearl-cli' ruby gem to the ruby server.

. ~/Repos/Scripts/bash/common/utilities.sh

cd ~/Repos/brightpearl-cli/
gem push brightpearl-cli-1.0.0.gem