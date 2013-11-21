# Ubuntu PHP & nginx deploy tools
This is a small collection of scripts and configuration files useful in case  you need to configure a clear **PHP5+nginx** shared server.

It's just a simple stub, configure it as you need.

However it runs out of the box. There's **no database** recipe.

## Quick and dirty how to
Install a clear copy of Ubuntu. It's tested on [Ubuntu 12.04 server](http://releases.ubuntu.com/precise/), but it may work also on different Debian based distro.

	git clone https://github.com/morafabio/ubuntu-web-deploy.git
	cd ubuntu-web-deploy
	cd install/
	./base.sh			# Base system
	./php-nginx.sh 		# PHP and nginx
	
In the `etc/` directory there are some pre-configured files, backup the original ones then copy in `/etc` overwriting the existing ones.
	
Add back in the root directory and move into users to add your first one:

	cd users/
	./adduser.sh
	
Answer all questions on the screen.

Create a new website root and configure it (replace USER and SITE properly):

	mkdir -p /home/USER/htdocs/SITE/htdocs
	chown -R USER:USER /home/USER/htdocs/SITE/htdocs
	vim /home/USER/etc/nginx/nginx.conf

Your `USER` should be allowed to access via `SFTP` at his own files.

Write the nginx configuration and when you're ready restart the services:

	service php5-fpm restart 
	service ssh restart 
	service nginx restart 

Access your virtual host via web.

## Script parts
### Base System

Bring the system up to date and generate locales.

The common utilities installed are building essentials, ghostscript, imagick, git.

It also make a stub for [Munin](http://munin-monitoring.org/) in `/var/www/tools/munin`.

You may need to to restart: whatch the screen.

It's working on [Ubuntu 12.04 server](http://releases.ubuntu.com/precise/).

**Invoke**
	
	cd install
	./base.sh

### PHP5 and nginx

Installs PHP5.4 from `ppa:ondrej/php5-oldstable` repository and many useful modules. The goal is running common web frameworks such as Wordpress or Symfony2.

**Invoke**
	
	cd install
	./php-nginx.sh

## Users

### Add

This script adds an user to the system.

	cd users/
	./adduser.sh [username] [email] [fpm-port]

Step by steps it:

* Checks the username, eMail and FPM port
* Configure the SFTP access
* Set permissions and the home skeleton
* Set the `.forward` file
* Make a stub of nginx configuration
* Generate an SSH key
* Make the FPM pool by parameter substitution


### Remove

This script remove an user and his files from the system.

	cd users/
	./adduser.sh [username]
	
	
## More, author and pull requests

Look at the code, it's quite easy to understand :-)!

My name is [Fabio Mora](http://fabio.mora.name) and this collection of scripts is released under **public domain**.

Feel free to submit your pull request or getting in touch.

**Cheers!**