#!/bin/sh

. ~/Repos/Scripts/bash/common/common-utilities.sh

sudo cp ~/Repos/Scripts/backup/hosts /private/etc/hosts
message green "SUCCESS" "Updated: \033[33m/private/etc/hosts\033[0m"
sudo cp ~/Repos/Scripts/backup/httpd.conf /private/etc/apache2/httpd.conf
message green "SUCCESS" "Updated: \033[33m/private/etc/apache2/extra/httpd-vhosts.conf\033[0m"
sudo cp ~/Repos/Scripts/backup/httpd-vhosts.conf /private/etc/apache2/extra/httpd-vhosts.conf
message green "SUCCESS" "Updated: \033[33m/private/etc/apache2/httpd.conf\033[0m"
sudo cp ~/Repos/Scripts/backup/php.ini /private/etc/php.ini
message green "SUCCESS" "Updated: \033[33m/private/etc/php.ini\033[0m"
message magenta "SUCCESS" "Restarted Apache"
sudo apachectl restart
message magenta "SUCCESS" "Flushed DNS Cache"
dscacheutil -flushcache

exit