#!/usr/bin/env bash

. /etc/profile
. /usr/local/bin/docker-entrypoint-functions.sh

MYUSER="${APPUSER}"
MYUID="${APPUID}"
MYGID="${APPGID}"

AutoUpgrade
ConfigureUser

if [ "$1" == 'couchpotato' ]; then
  DockLog "Fixing permissions on /config /opt/sickrage" 
  chown -R "${MYUSER}":"${MYUSER}" /config /opt/couchpotato
  chmod -R g+w /config /opt/couchpotato
  RunDropletEntrypoint
  DockLog "Starting app: ${1}"
  exec su-exec "${MYUSER}" python /opt/couchpotato/CouchPotato.py --console_log --data_dir=/config/ --config_file=/config/config.ini
else
  DockLog "Starting app: ${@}"
  exec "$@"
fi
