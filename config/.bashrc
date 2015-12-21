# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

>>> NIMZO ALIASES <<<

### SYSTEM ###################
alias chmod-shell-scripts='$HOME/Repos/nimzo-ruby/scripts/system/chmod-shell-scripts.sh'
alias show-path-variables='$HOME/Repos/nimzo-ruby/scripts/system/show-path-variables.sh'

parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    echo "[$git_branch]"
}
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\[\033[01;32m\]\$(parse_git_branch)\[\033[00m\]$ "