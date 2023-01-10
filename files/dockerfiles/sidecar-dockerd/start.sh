#!/usr/bin/env bash
# Remove the docker.pid file.
if [ -f /var/run/docker.pid ]; then
    rm /var/run/docker.pid
fi

# Run the dockerd daemon.
exec "$@"
