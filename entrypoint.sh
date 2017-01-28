#!/bin/bash

if [ ! "$(ls -A /omd/sites/demo/etc)" ];
then
    # Populate etc/ directory
    rsync -av /omd/sites/demo/etc.docker/ /omd/sites/demo/etc/
fi
if [ ! "$(ls -A /omd/sites/demo/var)" ];
then
    # Populate var/ directory
    rsync -av /omd/sites/demo/var.docker/ /omd/sites/demo/var/
fi

chown -R demo:demo /omd/sites/demo/etc

service apache2 restart

omd start demo

omd status

/bin/bash