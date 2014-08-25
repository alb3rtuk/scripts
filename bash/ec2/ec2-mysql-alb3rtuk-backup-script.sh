#!/bin/sh

mysqldump -h ${EC2_MYSQL_ALB3RTUK_HOST} -P 3306 -u ${EC2_MYSQL_ALB3RTUK_ROOT_USER} -p${EC2_MYSQL_ALB3RTUK_ROOT_PASS} alb3rtuk > ${filename}