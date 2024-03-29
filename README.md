# docker-distro

A guide and environment for creating a working Linux distro inside a Docker container.


## Why?

- VMs use more memory than containers.
- VMs use more CPU time than containers.
- VMs have higher I/O overhead.
- Most importantly, because you can.
- To learn about Linux, root pivoting, and the entire init process to multi-user mode.
- *New:* You have an Nvidia GPU but can't get PCI passthrough working inside a VM.

## Prerequisites

- Docker

## Resources

- [List of footguns with running a Distro in Docker.](./FOOTGUNS.md)

## Guide

[01: Bootstrapping a Distro Inside Docker](./guide/01-bootstrap.md)  
[02: Pivoting Into a Running Distro](./guide/02-pivoting.md)  
[03: Migrate to Multi-user Mode](./guide/03-multiuser.md)  
[04: Basic Command-Line Setup](./guide/04-cli-setup.md)  
[05: Networking Goodies](./guide/05-networking.md)  

### Extras

[GPU Acceleration (Nvidia)](./guide/xx-gpu-nvidia.md)  
> Get a hardware-accelerated desktop environment with full OpenGL, Vulkan, and NVENC support.  
> Note: *REQUIRES* Nvidia GPU; Does not support Intel or AMD.
