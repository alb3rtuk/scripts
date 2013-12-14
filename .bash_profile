
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# http://hackerslab.eu/blog/2013/04/a-little-better-ls-for-mac-osx/
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

alias arrange-brightpearl-dev="~/bin/bash/arrange-brightpearl-dev.sh"
alias close-all-windows="~/bin/bash/close-all-windows.sh"
alias empty-trash="~/bin/bash/empty-trash.sh"
alias open-bank-accounts='~/bin/bash/open-bank-accounts.sh'
alias run-ruby-tests='~/bin/bash/run-ruby-tests.sh'
alias vm='~/bin/bash/vm.sh'

parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    echo "[$git_branch]"
}
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]$ "
