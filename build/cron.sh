#!/usr/bin/env bash

env > /etc/environment
rsyslogd

/srv/dehydrated/dehydrated --register --accept-terms

# Spin until we receive a SIGTERM (e.g. from `docker stop`)
trap 'exit 0' INT TERM # SIGTERM
cron -f & wait ${!}
