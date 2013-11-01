#!/bin/bash
USER="$1"
EMAIL="$2"
FPM_PORT="$3"

HOME_BASE=/home/
WEB_GROUP=www-data
WEB_DIR=htdocs
SFTP_GROUP=sftp

# Check for username
if [ -z ${USER} ]; then
	read -p "What is the new username? " -e USER
fi
if [[ ! ${USER} =~ ^[a-z0-9]*$ ]]; then
	echo "$0: the username should match [a-z0-9]. Provided: ${USER}"
	exit 1;
fi

# Check for email
if [ -z ${EMAIL} ]; then
	read -p "What is the service email for this account? " -e EMAIL
fi

regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
if [[ ! ${EMAIL} =~ $regex  ]]; then
	echo "$0: the email must be valid. Provided: ${EMAIL}"
	exit 1;
fi

# Check for fpm-port
if [ -z ${FPM_PORT} ]; then
        read -p "What is the new FPM port? " -e FPM_PORT
fi
if [[ ! ${FPM_PORT} =~ ^[0-9]{4}$ ]]; then
        echo "$0: the port should be a number between 9001 and 9100. Provided: ${FPM_PORT}"
        exit 1;
fi

# Check if user already exists
groups ${USER}
if [ $? -eq 0 ]; then
	echo "$0: the username '${USER}' already exists."
	exit 1;
fi

echo "$0: adding '${USER}'."
useradd ${USER}
passwd ${USER}

# Disable shell
usermod -s /bin/false ${USER}

# Home directory
mkdir -p ${HOME_BASE}${USER} 
usermod -d ${HOME_BASE}${USER} ${USER}

# Web directory
mkdir -p ${HOME_BASE}${USER}/${WEB_DIR}
chown ${USER}:${WEB_GROUP} ${HOME_BASE}${USER}/${WEB_DIR}

# User dirs
for DIR in 'htdocs/session' tmp private log; do
	mkdir -p ${HOME_BASE}${USER}/${DIR}
	chown ${USER}:${USER} ${HOME_BASE}${USER}/${DIR}
	echo "$0: directory '${HOME_BASE}${USER}/${DIR}' created."
done

# Log dir history
echo "Creation date: "`date` > ${HOME_BASE}${USER}/logs/user_info

# Mail contact stuff
sudo -u ${USER} echo ${EMAIL} > ${HOME_BASE}${USER}/.forward

# SSH id_rsa
sudo -u ${USER} ssh-keygen -t rsa -C "${EMAIL}"

# Enable sftp login
groups ${SFTP_GROUP}
if [ $? -ne 0 ]; then
	addgroup ${SFTP_GROUP}
	echo "$0: group ${SFTP_GROUP} addedd."
fi

adduser ${USER} sftp
adduser ${USER} www-data

# Rewrite configuration files
cp -r ./etc/ ${HOME_BASE}${USER}/

for FILE in `find ${HOME_BASE}${USER}/etc/ -type f`; do
	sed -i "s/MY_USERNAME/${USER}/g" ${FILE}
	sed -i "s/MY_EMAIL/${EMAIL}/g" ${FILE}
	sed -i "s/MY_FPM_PORT/${FPM_PORT}/g" ${FILE}
done

ln -s ${HOME_BASE}${USER}/etc/nginx/nginx.conf /etc/nginx/sites-enabled/${USER}.conf
ln -s ${HOME_BASE}${USER}/etc/php5/php-fpm.conf /etc/php5/fpm/pool.d/${USER}.conf

echo "$0: done."
