#!/bin/sh

# Upload my ruby gems to ruby server. Specify gem name as argument (or 'brightpearl-cli' by default).

. ~/Repos/Scripts/bash/common/utilities.sh

ARG=$1

if [[ ${ARG} == 'brightpearl-cli' || ${ARG} == '' ]]; then

    cd ~/Repos/brightpearl-cli/
    sudo gem push brightpearl-cli-1.3.0.gem

elif [[ ${ARG} == 'columnist' ]]; then

    cd ~/Repos/columnist/
    sudo gem push columnist-1.1.0.gem

elif [[ ${ARG} == 'convoy' ]]; then

    cd ~/Repos/convoy/
    sudo gem push convoy-1.1.0.gem

elif [[ ${ARG} == 'nimzo' ]]; then

    cd ~/Repos/nimzo-ruby/nimzo-cli/
    sudo gem push nimzo-cli-1.0.0.gem

else

    echo
    message red "ERROR" "${ARG} is not a gem configured to upload."
    echo

fi

exit


