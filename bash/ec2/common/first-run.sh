#!/bin/sh
sudo su

#sudo apt-get update
#
### APACHE / PHP5 INSTALL
#sudo apt-get install apache2 php5 libapache2-mod-php5 -y
#
### GIT INSTALL
#sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev build-essential -y
#sudo apt-get install git-core -y
#
## MYSQL INSTALL
#sudo apt-get install mysql-server -y
#sudo apt-get install mysql-client -y



# PULL BROOKLINS REPO
if [ ! -d ~/repos/ ]; then
    mkdir repos
fi
if [ -d ~/repos/Brooklins/ ]; then
    rm -rf ~/repos/Brooklins/
fi
cd ~/repos
git clone https://github.com/alb3rtuk/Brooklins.git
cd /var
rm -rf www
mkdir www
cd /
cp -r ~/repos/Sleek/httpdocs/. /var/www