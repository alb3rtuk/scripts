#!/bin/sh

# Build the 'brightpearl-cli' ruby gem (or 'convoy' gem when called with ANY argument).

. ~/Repos/Scripts/bash/common/utilities.sh

ARG=$1

if [[ ${ARG} == 'brightpearl-cli' || ${ARG} == '' ]]; then

    cd ~/Repos/brightpearl-cli/
    sudo gem build brightpearl-cli.gemspec
    sudo gem install brightpearl-cli-1.0.0.gem

elif [[ ${ARG} == 'anchorman' ]]; then

    cd ~/Repos/anchorman/
    sudo gem build anchorman.gemspec
    sudo gem install anchorman-1.0.0.gem

elif [[ ${ARG} == 'convoy' ]]; then

    cd ~/Repos/convoy/
    sudo gem build convoy.gemspec
    sudo gem install convoy-1.0.0.gem

else

    echo
    message red "ERROR" "${ARG} is not a gem configured to build."
    echo

fi

exit