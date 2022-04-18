FROM ubuntu:latest

# Install Docker.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl && \
    curl -o- https://get.docker.com/ | bash - && \
    apt-get clean

# Set the entrypoint.
CMD [ \
    "dockerd",                                  \
    "--host", "unix://var/docker/docker.sock",  \
    "--data-root", "/var/docker"                \
]
