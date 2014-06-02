#!/bin/sh

# Commands used to setup a EC2 Instance (nimzo-maintanence)
sudo yum -y update
sudo yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel
sudo yum install -y wget
sudo yum install -y git
sudo yum install -y gcc make gcc-c++
sudo yum install -y httpd24 php54
sudo yum install -y php54-devel php54-mysql php54-pdo php54-mbstring php54-mcrypt
sudo yum install -y php-pear
sudo yum install -y pcre-devel
sudo yum install -y mysql
sudo yum install -y mysql-server
sudo yum install -y java-1.7.0-openjdk
sudo pear install Log

# Start Apache
sudo service httpd start # sudo apachectl start

# Install PHP APC module
sudo yum install -y php54-pecl-apc

# Auto Start Apache in EC2 Amazon Linux
sudo /sbin/chkconfig --levels 235 httpd on
sudo service httpd restart

# Install Apache Tomcat 7 (newer versions might be available at: http://tomcat.apache.org/download-70.cgi)
cd ~
mkdir tmp
cd tmp
wget http://mirror.gopotato.co.uk/apache/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz
tar xzvf apache-tomcat-7.0.54.tar.gz
sudo mkdir /usr/local/tomcat/
sudo mv apache-tomcat-7.0.54/* /usr/local/tomcat/
cd ..
rm -rf tmp/

# Start Tomcat
cd /usr/local/tomcat/bin
./startup.sh

# Setup GIT RSA key.
cd ~/.ssh
ssh-keygen -t rsa -C "*** GITHUB EMAIL *** " # NO PASSPHRASE!!
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub # <-- ADD THIS KEY TO GITHUB AND THEN RUN..
ssh -T git@github.com

# Clone into GIT Repos
cd ~
mkdir Repos
cd Repos
git clone git@github.com:alb3rtuk/nimzo-java.git
git clone git@github.com:alb3rtuk/nimzo-php.git
git clone git@github.com:alb3rtuk/nimzo-ruby.git
git clone git@github.com:alb3rtuk/sleek.git

# CHMOD shell scripts
cd ~/Repos/nimzo-ruby/scripts/system/
chmod 0755 chmod-shell-scripts.sh
./chmod-shell-scripts.sh

# Install PHPUnit
cd ~/
mkdir tmp
cd tmp
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit
cd ..
rm -rf tmp

# SETUP SUDOERS FILE (MUST ADD THE FOLLOWING LINES)
sudo visuo # DO NOT USE NANO OR PLAIN VIM!!!!!
# root       ALL=(ALL:ALL)      ALL
# ec2-user   ALL=(ALL:ALL)      ALL