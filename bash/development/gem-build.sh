#!/bin/sh

# Build my ruby gems. Specify gem name as argument (or 'brightpearl-cli' by default).

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

ARG=$1

if [[ ${ARG} == 'nimzo' || ${ARG} == 'nimzo-cli' || ${ARG} == 'n' ]]; then

    cd ~/Repos/nimzo-ruby/nimzo-cli/
    sudo gem build nimzo-cli.gemspec
    sudo gem install nimzo-cli-1.0.0.gem --backtrace -V -l

elif [[ ${ARG} == 'columnist' ]]; then

    cd ~/Repos/columnist/
    sudo gem build columnist.gemspec
    sudo gem install columnist-1.1.0.gem --backtrace -V -l

elif [[ ${ARG} == 'convoy' ]]; then

    cd ~/Repos/convoy/
    sudo gem build convoy.gemspec
    sudo gem install convoy-1.1.0.gem --backtrace -V -l

elif [[ ${ARG} == 'my' || ${ARG} == 'my-cli' || ${ARG} == 'm' ]]; then

    sudo cd ~/Repos/my-cli/

    core=(~/Repos/shared/ruby-core/*)
    shared=(~/Repos/shared/ruby-core/*)

    for ((i=0; i<${#core[@]}; i++)); do
        cp ${core[$i]} ~/Repos/my-cli/lib/core/
        echo "cp ${core[$i]} ~/Repos/my-cli/lib/core/"
    done

    cd ~/Repos/my-cli/
    sudo gem build my-cli.gemspec
    sudo gem install my-cli-1.0.0.gem --backtrace -V -l

    for ((i=0; i<${#core[@]}; i++)); do
        o=${core[$i]}
        f=~/Repos/shared/ruby-core/
        r=~/Repos/my-cli/lib/core/
        result="${o/$f/$r}"
        rm ${result}
        echo "rm ${result}"
    done

elif [[ ${ARG} == 'brightpearl' || ${ARG} == 'brightpearl-cli' || ${ARG} == 'b' || ${ARG} == '' ]]; then

    sudo cd ~/Repos/brightpearl-cli/

    core=(~/Repos/shared/ruby-core/*)
    shared=(~/Repos/shared/ruby-core/*)

    for ((i=0; i<${#core[@]}; i++)); do
        cp ${core[$i]} ~/Repos/brightpearl-cli/lib/core/
        echo "cp ${core[$i]} ~/Repos/brightpearl-cli/lib/core/"
    done

    cd ~/Repos/brightpearl-cli/
    sudo gem build brightpearl-cli.gemspec
    sudo gem install brightpearl-cli-1.3.0.gem --backtrace -V -l

    for ((i=0; i<${#core[@]}; i++)); do
        o=${core[$i]}
        f=~/Repos/shared/ruby-core/
        r=~/Repos/brightpearl-cli/lib/core/
        result="${o/$f/$r}"
        rm ${result}
        echo "rm ${result}"
    done

else

    echo
    message red "ERROR" "${ARG} is not a gem configured to build."
    echo

fi

exit