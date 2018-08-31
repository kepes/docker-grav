#!/bin/bash
set -e
shopt -s extglob

if ! [ -e user/config/system.yaml ]; then
  echo >&2 "No userfiles found - copying now..."
  rsync -a /tmp/grav-$GRAV_VERSION/user/ /var/www/html/user
fi
chown -Rf ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} user || true
echo >&2 "Complete! Grav has been successfully installed"

exec "$@"
