#!/bin/sh

MYUSER="couchpotato"
MYGID="10009"
MYUID="10009"
OS=""

DectectOS(){
  if [ -e /etc/alpine-release ]; then
    OS="alpine"
  elif [ -e /etc/os-release ]; then
    if /bin/grep -q "NAME=\"Ubuntu\"" /etc/os-release ; then
      OS="ubuntu"
    fi
  fi
}

AutoUpgrade(){
  if [ "${OS}" == "alpine" ]; then
    /sbin/apk --no-cache upgrade
    /bin/rm -rf /var/cache/apk/*
  elif [ "${OS}" == "ubuntu" ]; then
    export DEBIAN_FRONTEND=noninteractive
    /usr/bin/apt-get update
    /usr/bin/apt-get -y --no-install-recommends dist-upgrade
    /usr/bin/apt-get -y autoclean
    /usr/bin/apt-get -y clean
    /usr/bin/apt-get -y autoremove
    /bin/rm -rf /var/lib/apt/lists/*
  fi
}

ConfigureUser () {
  # Managing user
  if [ -n "${DOCKUID}" ]; then
    MYUID="${DOCKUID}"
  fi
  # Managing group
  if [ -n "${DOCKGID}" ]; then
    MYGID="${DOCKGID}"
  fi
  local OLDHOME
  local OLDGID
  local OLDUID
  if /bin/grep -q "${MYUSER}" /etc/passwd; then
    OLDUID=$(/usr/bin/id -u "${MYUSER}")
    OLDGID=$(/usr/bin/id -g "${MYUSER}")
    if [ "${DOCKUID}" != "${OLDUID}" ]; then
      OLDHOME=$(/bin/grep "$MYUSER" /etc/passwd | /usr/bin/awk -F: '{print $6}')
      /usr/sbin/deluser "${MYUSER}"
      /usr/bin/logger "Deleted user ${MYUSER}"
    fi
    if /bin/grep -q "${MYUSER}" /etc/group; then
      local OLDGID=$(/usr/bin/id -g "${MYUSER}")
      if [ "${DOCKGID}" != "${OLDGID}" ]; then
        /usr/sbin/delgroup "${MYUSER}"
        /usr/bin/logger "Deleted group ${MYUSER}"
      fi
    fi
  fi
  if ! /bin/grep -q "${MYUSER}" /etc/group; then
    /usr/sbin/addgroup -S -g "${MYGID}" "${MYUSER}"
  fi
  if ! /bin/grep -q "${MYUSER}" /etc/passwd; then
    /usr/sbin/adduser -S -D -H -s /sbin/nologin -G "${MYUSER}" -h "${OLDHOME}" -u "${MYUID}" "${MYUSER}"
  fi
  if [ -n "${OLDUID}" ] && [ "${DOCKUID}" != "${OLDUID}" ]; then
    /usr/bin/find / -user "${OLDUID}" -exec /bin/chown ${MYUSER} {} \;
  fi
  if [ -n "${OLDGID}" ] && [ "${DOCKGID}" != "${OLDGID}" ]; then
    /usr/bin/find / -group "${OLDGID}" -exec /bin/chgrp ${MYUSER} {} \;
  fi
}

DectectOS
AutoUpgrade
ConfigureUser

if [ "$1" = 'couchpotato' ]; then
    /bin/chown -R "${MYUSER}":"${MYUSER}" /config /opt/couchpotato
    /bin/chmod -R g+w /config /opt/couchpotato
    exec /sbin/su-exec "${MYUSER}" /usr/bin/python /opt/couchpotato/CouchPotato.py --console_log --data_dir=/config/ --config_file=/config/config.ini
fi

exec "$@"
