#!/bin/bash

# PHP Repositories 
add-apt-repository ppa:ondrej/php5-oldstable && apt-get update

# PHP Packages
apt-get -y install php5-cli php5-curl php5-gd php5-intl php-pear php5-imagick php5-mcrypt php5-memcache php5-sqlite php5-mysql php5-tidy php5-xmlrpc php5-xsl php5-intl php5-fpm php5-dev php-apc

pecl install pecl_http
echo "extension=http.so" > /etc/php5/conf.d/20-http.ini

# Nginx
apt-get install nginx

# phpMyAdmin
apt-get -y --no-install-recommends phpmyadmin
ln -s /usr/share/phpmyadmin/ /var/www/tools/phpmyadmin
