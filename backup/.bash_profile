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

### EC2 ######################
alias ec2-bootstrap='~/Repos/Scripts/bash/ec2/ec2-bootstrap.sh'
alias ec2-login-eu-ireland='~/Repos/Scripts/bash/ec2/ec2-login-eu-ireland.sh'
alias ec2-login-us-west-california='~/Repos/Scripts/bash/ec2/ec2-login-us-west-california.sh'
alias ec2-setup-eu-ireland='~/Repos/Scripts/bash/ec2/ec2-setup-eu-ireland.sh'
alias ec2-setup-us-west-california='~/Repos/Scripts/bash/ec2/ec2-setup-us-west-california.sh'

### QUICK COMMANDS ###########
alias decrypt='~/Repos/Scripts/bash/quick-commands/decrypt.sh'
alias encrypt='~/Repos/Scripts/bash/quick-commands/encrypt.sh'
alias rs='~/Repos/Scripts/bash/quick-commands/rs.sh'
alias vm='~/Repos/Scripts/bash/quick-commands/vm.sh'

### SCRIPTS ##################
alias update-sleek='~/Repos/Scripts/bash/scripts/update-sleek.sh'

### SELENIUM #################
alias open-nevil-road-surgery='~/Repos/Scripts/bash/selenium/open-nevil-road-surgery.sh'

### SYS ######################
alias chmod-shell-scripts='~/Repos/Scripts/bash/sys/chmod-shell-scripts.sh'
alias clear-terminal='~/Repos/Scripts/bash/sys/clear-terminal.sh'
alias close-all-windows='~/Repos/Scripts/bash/sys/close-all-windows.sh'
alias edit-bash='~/Repos/Scripts/bash/sys/edit-bash.sh'
alias edit-crontab='~/Repos/Scripts/bash/sys/edit-crontab.sh'
alias empty-trash='~/Repos/Scripts/bash/sys/empty-trash.sh'
alias find-files-larger-than-kb='~/Repos/Scripts/bash/sys/find-files-larger-than-kb.sh'
alias find-files-smaller-than-kb='~/Repos/Scripts/bash/sys/find-files-smaller-than-kb.sh'
alias tail-cron-mail='~/Repos/Scripts/bash/sys/tail-cron-mail.sh'
alias update-apache='~/Repos/Scripts/bash/sys/update-apache.sh'
alias update-bash-profile='~/Repos/Scripts/bash/sys/update-bash-profile.sh'
alias update-crontab='~/Repos/Scripts/bash/sys/update-crontab.sh'
alias update-launchd='~/Repos/Scripts/bash/sys/update-launchd.sh'

### TESTS ####################
alias run-ruby-tests='~/Repos/Scripts/bash/tests/run-ruby-tests.sh'

#####################################################################################################

parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    echo "[$git_branch]"
}
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\[\033[01;32m\]\$(parse_git_branch)\[\033[00m\]$ "