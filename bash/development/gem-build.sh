#!/bin/sh

# Build my ruby gems. Specify gem name as argument (or 'brightpearl-cli' by default).

. ~/Repos/Scripts/bash/common/utilities.sh

ARG=$1

if [[ ${ARG} == 'nimzo' || ${ARG} == 'nimzo-cli' || ${ARG} == '' ]]; then

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

elif [[ ${ARG} == 'brightpearl' || ${ARG} == 'brightpearl-cli' || ${ARG} == 'bp' ]]; then

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

      cd ~/Repos/brightpearl-cli/
      sudo gem build brightpearl-cli.gemspec
      sudo gem install brightpearl-cli-1.3.0.gem --backtrace -V -l

else

    echo
    message red "ERROR" "${ARG} is not a gem configured to build."
    echo

fi

exit