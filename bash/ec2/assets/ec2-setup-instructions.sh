#!/bin/sh

# Commands used to setup a EC2 Instance (nimzo-maintanence)
sudo yum update
sudo yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
sudo yum install wget
sudo yum install git
sudo yum install mysql
sudo yum install httpd
sudo yum install java-1.7.0-openjdk

# Install Apache Tomcat 7 (newer versions might be available at: http://tomcat.apache.org/download-70.cgi)
cd  ~
mkdir tmp
cd tmp
wget http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz
tar xzvf apache-tomcat-7.0.54.tar.gz
rm apache-tomcat-7.0.54.tar.gz
cd /usr/local
sudo mkdir tomcat
sudo mv ~/tmp/apache-tomcat-7.0.54/apache-tomcat-7.0.54/* tomcat/

# Start Apache
sudo apachectl start

# Start Tomcat
cd /usr/local/tomcat/bin
./startup.sh

# Setup GIT RSA key.
cd ~/.ssh
ssh-keygen -t rsa -C "*** GITHUB EMAIL ***"
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub # <-- ADD THIS KEY TO GITHUB AND THEN RUN..
ssh -T git@github.com

# Clone into GIT Repos
cd ~/
mkdir Repos
cd Repos
git clone git@github.com:alb3rtuk/nimzo-java.git
git clone git@github.com:alb3rtuk/nimzo-php.git
git clone git@github.com:alb3rtuk/nimzo-ruby.git

# CHMOD shell scripts
cd ~/Repos/nimzo-ruby/scripts/system/
chmod 0755 chmod-shell-scripts.sh
./chmod-shell-scripts.sh