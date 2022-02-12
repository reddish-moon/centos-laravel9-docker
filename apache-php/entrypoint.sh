#!/bin/sh

# docker-compose.ymlでvolumes使った時にも反映できるようにここでも叩く
su - user -c "cd /var/www/laravel &&
rm -fR ./vendor/* &&
COMPOSER_MEMORY_LIMIT=-1 composer install"

# stopした時にpidが残って起動できない事があるので削除
if [ -e /var/run/httpd/httpd.pid ] ; then rm -f /var/run/httpd/httpd.pid;fi
if [ -e /run/httpd/httpd.pid ] ; then rm -f /run/httpd/httpd.pid;fi

/usr/sbin/httpd $OPTIONS -DFOREGROUND
