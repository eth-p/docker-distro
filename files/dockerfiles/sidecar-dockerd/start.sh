#!/usr/bin/env bash
rm /var/run/docker.pid
exec "$@"
