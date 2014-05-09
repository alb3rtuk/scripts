[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

#####################################################################################################
#
# http://hackerslab.eu/blog/2013/04/a-little-better-ls-for-mac-osx/
#
# Must install GNU coreutils in order to work. More info at:
# http://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities
#
# Enable color support of ls and also add handy aliases..

alias ls='gls -F --color=auto'
alias la='ls -a'
alias lf='ls -FA'
alias ll='gvdir --color=auto'
alias llh='ls -lA'
alias dir='gdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# More (Misc) aliases..
alias sb='source ~/.bash_profile'
alias tig='/Users/Albert/bin/exec/tig'
alias mysql='mysql app -uroot'
alias composer='/usr/local/bin/composer/./composer.phar'

#####################################################################################################

### BANKING ##################
alias get-all-balances='~/Repos/Scripts/bash/banking/get-all-balances.sh'
alias get-barclaycard-balances='~/Repos/Scripts/bash/banking/get-barclaycard-balances.sh'
alias get-capitalone-balances='~/Repos/Scripts/bash/banking/get-capitalone-balances.sh'
alias get-credit-score='~/Repos/Scripts/bash/banking/get-credit-score.sh'
alias get-halifax-balances='~/Repos/Scripts/bash/banking/get-halifax-balances.sh'
alias get-lloyds-balances='~/Repos/Scripts/bash/banking/get-lloyds-balances.sh'
alias get-natwest-balances='~/Repos/Scripts/bash/banking/get-natwest-balances.sh'
alias open-all-banks='~/Repos/Scripts/bash/banking/open-all-banks.sh'
alias open-barclaycard='~/Repos/Scripts/bash/banking/open-barclaycard.sh'
alias open-capitalone='~/Repos/Scripts/bash/banking/open-capitalone.sh'
alias open-experian='~/Repos/Scripts/bash/banking/open-experian.sh'
alias open-halifax='~/Repos/Scripts/bash/banking/open-halifax.sh'
alias open-lloyds='~/Repos/Scripts/bash/banking/open-lloyds.sh'
alias open-natwest='~/Repos/Scripts/bash/banking/open-natwest.sh'
alias pay-barclaycard='~/Repos/Scripts/bash/banking/pay-barclaycard.sh'
alias pay-capitalone='~/Repos/Scripts/bash/banking/pay-capitalone.sh'
alias pay-lloyds='~/Repos/Scripts/bash/banking/pay-lloyds.sh'

### CHEF #####################
alias chef-cookbook-create='~/Repos/Scripts/bash/chef/chef-cookbook-create.sh'
alias chef-cookbook-delete='~/Repos/Scripts/bash/chef/chef-cookbook-delete.sh'
alias chef-cookbook-download='~/Repos/Scripts/bash/chef/chef-cookbook-download.sh'
alias chef-cookbook-upload='~/Repos/Scripts/bash/chef/chef-cookbook-upload.sh'

### EC2 ######################
alias ec2-create='~/Repos/Scripts/bash/ec2/ec2-create.sh'
alias ec2-delete='~/Repos/Scripts/bash/ec2/ec2-delete.sh'
alias ec2-list='~/Repos/Scripts/bash/ec2/ec2-list.sh'
alias ec2-login='~/Repos/Scripts/bash/ec2/ec2-login.sh'

### NIMZO ########€€##########
alias nimzo-chown='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-chown.sh'
alias nimzo-compile-less='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-compile-less.sh'
alias nimzo-create='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-create.sh'
alias nimzo-delete='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-remove.sh'
alias nimzo-generate-test='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-generate-test.sh'
alias nimzo-remove='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-remove.sh'
alias nimzo-rewrite='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-rewrite.sh'
alias nimzo-run-tests='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests.sh'
alias nimzo-run-tests-php='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-php.sh'
alias nimzo-run-tests-php-debug='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-php-debug.sh'
alias nimzo-run-tests-php-isolated='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-php-isolated.sh'
alias nimzo-run-tests-ruby='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-ruby.sh'
alias nimzo-show-groups='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-show-groups.sh'
alias nimzo-show-routes='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-show-routes.sh'
alias nimzo-tail-logs='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-tail-logs.sh'
alias nimzo-update='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-update.sh'
alias nimzo-update-sleek='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-update-sleek.sh'
alias nimzo-watcher='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-watcher.sh'

### NIMZO (SHORT) ############
alias ncl='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-compile-less.sh'
alias nc='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-create.sh'
alias ngt='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-generate-test.sh'
alias nd='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-remove.sh'
alias nr='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-remove.sh'
alias nt='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests.sh'
alias ntp='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-php.sh'
alias ntpd='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-php-debug.sh'
alias ntpi='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-php-isolated.sh'
alias ntr='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-run-tests-ruby.sh'
alias nsg='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-show-groups.sh'
alias nsr='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-show-routes.sh'
alias ntl='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-tail-logs.sh'
alias nu='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-update.sh'
alias nus='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-update-sleek.sh'
alias nw='~/Repos/Nimzo-Ruby/scripts/bash/nimzo-watcher.sh'

### SCRIPTS ##################
alias create-launchd='~/Repos/Scripts/bash/scripts/create-launchd.sh'
alias decrypt='~/Repos/Scripts/bash/scripts/decrypt.sh'
alias encrypt='~/Repos/Scripts/bash/scripts/encrypt.sh'
alias rs='~/Repos/Scripts/bash/scripts/rs.sh'
alias tail-cron-mail='~/Repos/Scripts/bash/scripts/tail-cron-mail.sh'
alias update-apache='~/Repos/Scripts/bash/scripts/update-apache.sh'
alias update-bash-profile='~/Repos/Scripts/bash/scripts/update-bash-profile.sh'
alias update-crontab='~/Repos/Scripts/bash/scripts/update-crontab.sh'
alias update-launchd='~/Repos/Scripts/bash/scripts/update-launchd.sh'
alias update-sleek='~/Repos/Scripts/bash/scripts/update-sleek.sh'

### SELENIUM #################
alias open-nevil-road-surgery='~/Repos/Scripts/bash/selenium/open-nevil-road-surgery.sh'

### SYS ######################
alias chmod-shell-scripts='~/Repos/Scripts/bash/sys/chmod-shell-scripts.sh'
alias clear-terminal='~/Repos/Scripts/bash/sys/clear-terminal.sh'
alias close-all-windows='~/Repos/Scripts/bash/sys/close-all-windows.sh'
alias edit-crontab='~/Repos/Scripts/bash/sys/edit-crontab.sh'
alias empty-trash='~/Repos/Scripts/bash/sys/empty-trash.sh'
alias find-files-larger-than-kb='~/Repos/Scripts/bash/sys/find-files-larger-than-kb.sh'
alias find-files-smaller-than-kb='~/Repos/Scripts/bash/sys/find-files-smaller-than-kb.sh'
alias get-octal-value='~/Repos/Scripts/bash/sys/get-octal-value.sh'

### TESTS ####################
alias run-ruby-tests='~/Repos/Scripts/bash/tests/run-ruby-tests.sh'

### TESTS ####################
alias tomcat-restart='~/Repos/Scripts/bash/tomcat/tomcat-restart.sh'
alias tomcat-start='~/Repos/Scripts/bash/tomcat/tomcat-start.sh'
alias tomcat-stop='~/Repos/Scripts/bash/tomcat/tomcat-stop.sh'

#####################################################################################################

parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    echo "[$git_branch]"
}
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\[\033[01;32m\]\$(parse_git_branch)\[\033[00m\]$ "