#!/bin/bash
USER="$1"

HOME_BASE=/home/

# Check for username
if [ -z $USER ]; then
        read -p "What is your username? " -e USER
fi
if [[ ! ${USER} =~ ^[a-z0-9]*$ ]]; then
        echo "$0: the username should match [a-z0-9]. Provided: ${USER}"
        exit 1;
fi

# Check if user exists
groups ${USER}
if [ $? -nq 0 ]; then
	echo "$0: the username '${USER}' already exists."
	exit 1;
fi

echo "$0: deleting '${USER}'."

deluser ${USER}
rm -rf ${HOME_BASE}${USER}

rm /etc/nginx/sites-enabled/${USER}.conf
rm /etc/php5/fpm/pool.d/${USER}.conf
 
echo "$0: deleted '${USER}'."
