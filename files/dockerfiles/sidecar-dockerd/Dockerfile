FROM ubuntu:latest

# Install Docker and OpenSSH.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl openssh-client && \
    curl -o- https://get.docker.com/ | bash - && \
    apt-get clean

# Symlink /var/lib/docker to /var/docker.
# This is needed because `docker plugin` doesn't respect the data-root.
ln -s "/var/docker" /var/lib/docker

# Copy the start script.
COPY start.sh /

# Set the entrypoint.
CMD [ \
    "sh", "/start.sh",                          \
    "dockerd",                                  \
    "--host", "unix://var/docker/docker.sock",  \
    "--data-root", "/var/docker"                \
]
