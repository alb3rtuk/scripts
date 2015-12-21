#!/bin/sh

. ~/Repos/scripts/bash/common/utilities.sh

sudo cp ~/Repos/scripts/config/hosts /private/etc/hosts
message green "SUCCESS" "Updated: \033[33m/private/etc/hosts\033[0m"

sudo cp ~/Repos/scripts/config/exports /private/etc/exports
message green "SUCCESS" "Updated: \033[33m/private/etc/exports\033[0m"

sudo cp ~/Repos/scripts/config/httpd.conf /private/etc/apache2/httpd.conf
message green "SUCCESS" "Updated: \033[33m/private/etc/apache2/httpd.conf\033[0m"

sudo cp ~/Repos/scripts/config/httpd-vhosts.conf /private/etc/apache2/extra/httpd-vhosts.conf
message green "SUCCESS" "Updated: \033[33m/private/etc/apache2/extra/httpd-vhosts.conf\033[0m"

sudo cp ~/Repos/scripts/config/php.ini /private/etc/php.ini
message green "SUCCESS" "Updated: \033[33m/private/etc/php.ini\033[0m"

sudo cp ~/Repos/scripts/config/hosts /etc/hosts
message green "SUCCESS" "Updated: \033[33m/etc/hosts\033[0m"

sudo nfsd restart
message magenta "SUCCESS" "Restarted NFS"

sudo apachectl restart
message magenta "SUCCESS" "Restarted Apache"

dscacheutil -flushcache
message magenta "SUCCESS" "Flushed DNS Cache"

sudo apachectl configtest

exit