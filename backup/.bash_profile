[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"                  # Load the default .profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session *as a function*
[[ -s "$HOME/.nvm/nvm.sh" ]] && source ~/.nvm/nvm.sh                  # Load NVM

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH=$PATH:$HOME/Bin/php_codesniffer/scripts/
export PATH=$PATH:$HOME/Bin/phpmd/src/bin
export PATH=$PATH:$HOME/Bin/exec

export PYTHONPATH=`brew --prefix`/lib/python2.7/site-packages:$PYTHONPATH

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export JAVA_HOME=$(/usr/libexec/java_home)
export MAVEN_HOME="/usr/local/Cellar/maven/3.2.1/libexec"
export TOMCAT_HOME="/Library/Tomcat-7"
export CATALINA_HOME="/Library/Tomcat-7"

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
alias apigen='php $HOME/Repos/nimzo-php-docs/lib/apigen.php'

alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

#####################################################################################################

### CHEF #####################
alias chef-cookbook-create='~/Repos/scripts/bash/chef/chef-cookbook-create.sh'
alias chef-cookbook-delete='~/Repos/scripts/bash/chef/chef-cookbook-delete.sh'
alias chef-cookbook-download='~/Repos/scripts/bash/chef/chef-cookbook-download.sh'
alias chef-cookbook-upload='~/Repos/scripts/bash/chef/chef-cookbook-upload.sh'

### DEVELOPMENT ##############
alias gem-build='~/Repos/scripts/bash/development/gem-build.sh'
# alias gem-bump='~/Repos/scripts/bash/development/gem-bump.sh'
alias gem-upload='~/Repos/scripts/bash/development/gem-upload.sh'
alias tail-catalina-out='~/Repos/scripts/bash/development/tail-catalina-out.sh'
alias tail-php-logs='~/Repos/scripts/bash/development/tail-php-logs.sh'
alias tomcat-restart='~/Repos/scripts/bash/development/tomcat-restart.sh'
alias tomcat-start='~/Repos/scripts/bash/development/tomcat-start.sh'
alias tomcat-stop='~/Repos/scripts/bash/development/tomcat-stop.sh'

### EC2 ######################
alias ec2-backup-alb3rtuk='~/Repos/scripts/bash/ec2/ec2-backup-alb3rtuk.sh'
alias ec2-create='~/Repos/scripts/bash/ec2/ec2-create.sh'
alias ec2-delete='~/Repos/scripts/bash/ec2/ec2-delete.sh'
alias ec2-list='~/Repos/scripts/bash/ec2/ec2-list.sh'
alias ec2-mysql-alb3rtuk-backup='~/Repos/scripts/bash/ec2/ec2-mysql-alb3rtuk-backup.sh'
alias ec2-mysql-alb3rtuk-login='~/Repos/scripts/bash/ec2/ec2-mysql-alb3rtuk-login.sh'
alias ec2-mysql-nimzo-backup='~/Repos/scripts/bash/ec2/ec2-mysql-nimzo-backup.sh'
alias ec2-mysql-nimzo-login='~/Repos/scripts/bash/ec2/ec2-mysql-nimzo-login.sh'
alias ec2-mysql-nimzo-setup='~/Repos/scripts/bash/ec2/ec2-mysql-nimzo-setup.sh'
alias ec2-server-deploy-ebay-service='~/Repos/scripts/bash/ec2/ec2-server-deploy-ebay-service.sh'
alias ec2-server-login='~/Repos/scripts/bash/ec2/ec2-server-login.sh'
alias ec2-server-update='~/Repos/scripts/bash/ec2/ec2-server-update.sh'
alias ec2-server-update-php='~/Repos/scripts/bash/ec2/ec2-server-update-php.sh'

### GIT ######################
alias git-sync-all='~/Repos/scripts/bash/git/git-sync-all.sh'
alias git-status-all='~/Repos/scripts/bash/git/git-status-all.sh'

>>> NIMZO ALIASES <<<

### SCRIPTS ##################
alias mate='~/Repos/scripts/bash/scripts/mate.sh'
alias color='~/Repos/scripts/bash/scripts/colors.sh'
alias colors='~/Repos/scripts/bash/scripts/colors.sh'
alias create-launchd='~/Repos/scripts/bash/scripts/create-launchd.sh'
alias decrypt='~/Repos/scripts/bash/scripts/decrypt.sh'
alias encrypt='~/Repos/scripts/bash/scripts/encrypt.sh'
alias hex-convert='~/Repos/scripts/bash/scripts/hex-convert.sh'
alias lotto-predicter='~/Repos/scripts/bash/scripts/lotto-predicter.sh'
alias my-finances='~/Repos/scripts/bash/scripts/my-finances.sh'
alias my-finances-with-ids='~/Repos/scripts/bash/scripts/my-finances-with-ids.sh'
alias my-finances-with-internal-transfers='~/Repos/scripts/bash/scripts/my-finances-with-internal-transfers.sh'
alias my-finances-untranslated='~/Repos/scripts/bash/scripts/my-finances-untranslated.sh'
alias my-scripts='~/Repos/scripts/bash/scripts/my-scripts.sh'
alias rename-files='~/Repos/scripts/bash/scripts/rename-files.sh'
alias rs='~/Repos/scripts/bash/scripts/rs.sh'
alias tail-cron-mail='~/Repos/scripts/bash/scripts/tail-cron-mail.sh'
alias update-apache='~/Repos/scripts/bash/scripts/update-apache.sh'
alias update-bash-profile='~/Repos/scripts/bash/scripts/update-bash-profile.sh'
alias update-crontab='~/Repos/scripts/bash/scripts/update-crontab.sh'
alias update-launchd='~/Repos/scripts/bash/scripts/update-launchd.sh'

### SELENIUM #################
alias get-bank-transactions='~/Repos/scripts/bash/selenium/get-bank-transactions.sh'
alias open-barclaycard='~/Repos/scripts/bash/selenium/open-barclaycard.sh'
alias open-capitalone='~/Repos/scripts/bash/selenium/open-capitalone.sh'
alias open-experian='~/Repos/scripts/bash/selenium/open-experian.sh'
alias open-halifax='~/Repos/scripts/bash/selenium/open-halifax.sh'
alias open-lloyds='~/Repos/scripts/bash/selenium/open-lloyds.sh'
alias open-natwest='~/Repos/scripts/bash/selenium/open-natwest.sh'
alias open-nevil-road-surgery='~/Repos/scripts/bash/selenium/open-nevil-road-surgery.sh'

### SHOW #####################
alias show-bank-transactions='~/Repos/scripts/bash/show/show-bank-transactions.sh'

### SLEEK ####################
alias sleek-iconsign-find-non-collected='~/Repos/scripts/bash/sleek/sleek-iconsign-find-non-collected.sh'
alias sleek-iconsign-fix='~/Repos/scripts/bash/sleek/sleek-iconsign-fix.sh'
alias sleek-process-orders='~/Repos/scripts/bash/sleek/sleek-process-orders.sh'

### SYS ######################
alias clear-terminal='~/Repos/scripts/bash/sys/clear-terminal.sh'
alias close-all-windows='~/Repos/scripts/bash/sys/close-all-windows.sh'
alias edit-crontab='~/Repos/scripts/bash/sys/edit-crontab.sh'
alias empty-trash='~/Repos/scripts/bash/sys/empty-trash.sh'
alias find-files-larger-than-kb='~/Repos/scripts/bash/sys/find-files-larger-than-kb.sh'
alias find-files-smaller-than-kb='~/Repos/scripts/bash/sys/find-files-smaller-than-kb.sh'
alias get-octal-value='~/Repos/scripts/bash/sys/get-octal-value.sh'
alias symlink-all='~/Repos/scripts/bash/sys/symlink-all.sh'

### TESTS ####################
alias run-ruby-tests='~/Repos/scripts/bash/tests/run-ruby-tests.sh'

#####################################################################################################

parse_git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    echo "[$git_branch]"
}
PS1="${debian_chroot:+($debian_chroot)}\[\033[38;5;45m\]\u@\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[00m\]\[\033[38;5;118m\]\$(parse_git_branch)\[\033[00m\]$ "

#####################################################################################################

### BRIGHTPEARL ALIASES ######
alias vm='sshpass -palbert ssh albert@172.27.2.253'
alias vm-root='sshpass -palbert ssh albert@172.27.2.253 -t su root'
alias lakshmi='sshpass -plakshmi ssh lakshmi@172.27.6.56'
alias jenkins-0='sshpass -pvmuser ssh vmuser@euw1-buildslave-0000.brightpearl.com'
alias jenkins-1='sshpass -pvmuser ssh vmuser@euw1-buildslave-0001.brightpearl.com'
alias jenkins-2='sshpass -pvmuser ssh vmuser@euw1-buildslave-0002.brightpearl.com'
alias jenkins-3='sshpass -pvmuser ssh vmuser@euw1-buildslave-0003.brightpearl.com'
alias raptorkins='sshpass -pjenkins ssh jenkins@raptorkins'
alias raptorslave='sshpass -praptor ssh raptor@raptorslave.gbbr.brightpearl.com'
alias skybutler='ssh -i ~/.ssh/Brightpearl-DevInf.pem jenkins@skybutler.brightpearl.com'

### TMP ######################
alias bp-build='~/Repos/brightpearl-scripts/tmp/bp-build.sh'
alias bp-cleanup='~/Repos/brightpearl-scripts/tmp/bp-cleanup.sh'
alias bp-compile-less='~/Repos/brightpearl-scripts/tmp/bp-compile-less.sh'
alias bp-create-branch='~/Repos/brightpearl-scripts/tmp/bp-create-branch.sh'
alias bp-merge-to-master='~/Repos/brightpearl-scripts/tmp/bp-merge-to-master.sh'
alias bp-new-branch='~/Repos/brightpearl-scripts/tmp/bp-new-branch.sh'
alias bp-setup-ebay='~/Repos/brightpearl-scripts/tmp/bp-setup-ebay.sh'

### TMP-PRIVATE ##############
alias bp-thunder='~/Repos/brightpearl-scripts/tmp-private/bp-thunder.sh'
alias bp-thunder-fix='~/Repos/brightpearl-scripts/tmp-private/bp-thunder-fix.sh'

### BRIGHTPEARL EXPORTS ######
export APP_HOSTNAME=brightpearl.dsk-web-gbbr-253.gbbr.brightpearl.com
export APP_ACCOUNT=automation