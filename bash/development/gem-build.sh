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

copy_shared_files() {
    core=(~/Repos/shared/ruby-core/*)
    routes=(~/Repos/shared/ruby-routes/*)
    for ((i=0; i<${#core[@]}; i++)); do
        cp ${core[$i]} $1
        echo "cp ${core[$i]} $1"
    done
    for ((i=0; i<${#routes[@]}; i++)); do
        cp ${routes[$i]} $2
        echo "cp ${routes[$i]} $2"
    done
}

remove_shared_files() {
    core=(~/Repos/shared/ruby-core/*)
    routes=(~/Repos/shared/ruby-routes/*)
    for ((i=0; i<${#core[@]}; i++)); do
        o=${core[$i]}
        f=~/Repos/shared/ruby-core/
        r=$1
        result="${o/$f/$r}"
        rm ${result}
        echo "rm ${result}"
    done
    for ((i=0; i<${#routes[@]}; i++)); do
        o=${routes[$i]}
        f=~/Repos/shared/ruby-routes/
        r=$2
        result="${o/$f/$r}"
        rm ${result}
        echo "rm ${result}"
    done
}

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

    copy_shared_files ~/Repos/my-cli/lib/core/ ~/Repos/my-cli/lib/routes/

    cd ~/Repos/my-cli/
    sudo gem build my-cli.gemspec
    sudo gem install my-cli-1.0.0.gem --backtrace -V -l

    remove_shared_files ~/Repos/my-cli/lib/core/ ~/Repos/my-cli/lib/routes/

elif [[ ${ARG} == 'brightpearl' || ${ARG} == 'brightpearl-cli' || ${ARG} == 'b' || ${ARG} == '' ]]; then

    sudo cd ~/Repos/brightpearl-cli/

    copy_shared_files ~/Repos/brightpearl-cli/lib/core/ ~/Repos/brightpearl-cli/lib/routes/

    cd ~/Repos/brightpearl-cli/
    sudo gem build brightpearl-cli.gemspec
    sudo gem install brightpearl-cli-1.4.0.gem --backtrace -V -l

    remove_shared_files ~/Repos/brightpearl-cli/lib/core/ ~/Repos/brightpearl-cli/lib/routes/

else

    echo
    message red "ERROR" "${ARG} is not a gem configured to build."
    echo

fi

exit