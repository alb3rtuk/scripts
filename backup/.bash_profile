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
alias ll='ls -lA'
alias dir='gdir --color=auto'
alias vdir='gvdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# More (Misc) aliases..
alias sb='source ~/.bash_profile'
alias tig='/Users/Albert/bin/exec/tig'

#####################################################################################################

### CRON #####################

### OPEN #####################
alias open-all-banks='~/Repos/Scripts/bash/open/open-all-banks.sh'
alias open-halifax='~/Repos/Scripts/bash/open/open-halifax.sh'
alias open-natwest='~/Repos/Scripts/bash/open/open-natwest.sh'
alias open-lloyds='~/Repos/Scripts/bash/open/open-lloyds.sh'
alias open-capitalone='~/Repos/Scripts/bash/open/open-capitalone.sh'
alias open-barclaycard='~/Repos/Scripts/bash/open/open-barclaycard.sh'

### QUICK COMMANDS ###########
alias rs='~/Repos/Scripts/bash/quick-commands/rs.sh'
alias vm='~/Repos/Scripts/bash/quick-commands/vm.sh'

### SYS ######################
alias chmod-shell-scripts='~/Repos/Scripts/bash/sys/chmod-shell-scripts.sh'
alias close-all-windows='~/Repos/Scripts/bash/sys/close-all-windows.sh'
alias edit-bash='~/Repos/Scripts/bash/sys/edit-bash.sh'
alias edit-crontab='~/Repos/Scripts/bash/sys/edit-crontab.sh'
alias empty-trash='~/Repos/Scripts/bash/sys/empty-trash.sh'

### RUN ####################
alias run-ruby-tests='~/Repos/Scripts/bash/run/run-ruby-tests.sh'

### UPDATE ###################
alias update-bash-profile='~/Repos/Scripts/bash/update/update-bash-profile.sh'
alias update-crontab='~/Repos/Scripts/bash/update/update-crontab.sh'

#####################################################################################################

parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    echo "[$git_branch]"
}
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\[\033[01;32m\]\$(parse_git_branch)\[\033[00m\]$ "