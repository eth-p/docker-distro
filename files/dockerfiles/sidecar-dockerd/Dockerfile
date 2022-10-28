FROM ubuntu:latest

# Install Docker and OpenSSH.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl openssh-client && \
    curl -o- https://get.docker.com/ | bash - && \
    apt-get clean

# Copy the start script.
COPY start.sh /

# Set the entrypoint.
CMD [ \
    "sh", "/start.sh",                          \
    "dockerd",                                  \
    "--host", "unix://var/docker/docker.sock",  \
    "--data-root", "/var/docker"                \
]
