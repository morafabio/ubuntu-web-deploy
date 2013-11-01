#!/bin/bash

# System upgrade
apt-get update && apt-get -y dist-upgrade

# Custom packages
apt-get -y install build-essential ghostscript imagemagick python-software-properties git munin libcurl3-openssl-dev
 
# Locale regeneration
locale-gen it_IT.UTF-8 && dpkg-reconfigure locales

# Core www
mkdir -p /var/www/tools

# Munin
ln -s /var/cache/munin/www/ /var/www/tools/munin
