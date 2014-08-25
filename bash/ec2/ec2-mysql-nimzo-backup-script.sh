#!/bin/sh

mysqldump -h ${EC2_MYSQL_NIMZO_HOST} -P 3306 -u ${EC2_MYSQL_NIMZO_ROOT_USER} -p${EC2_MYSQL_NIMZO_ROOT_PASS} nimzo > ${filename}