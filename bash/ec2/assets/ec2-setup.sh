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

# Test DB connection latency.
time mysql -h nimzo-client-config.cr27trwznlei.eu-west-1.rds.amazonaws.com -u root -pLkqhacyp\$52 -e 'quit'
