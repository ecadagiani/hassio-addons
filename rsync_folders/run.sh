#!/usr/bin/env bashio
# shellcheck shell=bash

set -e

bashio::log.info "Starting Rsync Folders"

######### VARIABLES
HOST=$(bashio::config 'remote_host')
USERNAME=$(bashio::config 'username')
PASSWORD=$(bashio::config 'password')
REMOTE_FOLDER=$(bashio::config 'remote_folder')
FOLDERS=$(bashio::config 'folders')
USE_SSH=$(bashio::config 'use_ssh')

######### PORT
if bashio::config.has_value 'remote_port'; then
	PORT=$(bashio::config 'remote_port')
else
	PORT=22
fi
bashio::log.info "Use port $PORT"

######### OPTIONS
if bashio::config.has_value 'options'; then
	OPTIONS=$(bashio::config 'options')
else
	OPTIONS='-archive --recursive --compress --delete --prune-empty-dirs'
fi
bashio::log.info "Use options $OPTIONS"


RSYNC_URL="$USERNAME@$HOST:$REMOTE_FOLDER"

bashio::log.info "Start rsync backups to $RSYNC_URL"

for folder in $FOLDERS; do
	bashio::log.info "Sync $folder -> ${REMOTE_FOLDER}"
	# shellcheck disable=SC2086

	if [ $USE_SSH -ge 1 ]; then
    	sshpass -p $PASSWORD rsync -va -e "ssh -p $PORT -o StrictHostKeyChecking=no" /$folder/ $RSYNC_URL
	else
		sshpass -p $PASSWORD rsync -va /$folder/ $RSYNC_URL
	fi
done


bashio::log.info "Finished to sync all folders"