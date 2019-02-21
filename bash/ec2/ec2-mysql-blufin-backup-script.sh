#!/bin/sh

mysqldump -h ${EC2_MYSQL_BLUFIN_HOST} -P 3306 -u ${EC2_MYSQL_BLUFIN_ROOT_USER} -p${EC2_MYSQL_BLUFIN_ROOT_PASS} blufin > ${filename}