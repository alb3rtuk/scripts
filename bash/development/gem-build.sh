#!/bin/sh

# Build the 'brightpearl-cli' ruby gem (or 'convoy' gem when called with ANY argument).

. ~/Repos/Scripts/bash/common/utilities.sh

ARG=$1

if [[ ${ARG} != '' ]]; then

    cd ~/Repos/convoy/
    sudo gem build convoy.gemspec
    sudo gem install convoy-1.0.0.gem

else

    cd ~/Repos/brightpearl-cli/
    sudo gem build brightpearl-cli.gemspec
    sudo gem install brightpearl-cli-1.0.0.gem

fi

exit