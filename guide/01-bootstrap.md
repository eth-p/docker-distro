# 01: Bootstrapping a Distro Inside Docker

When we run a Linux distro from within Docker, we don't want to be running inside the ephemeral storage of a container.
Instead, we're going to take a base image and copy it outside to a bind mounted host directory.

For this guide, I will be using [Arch Linux](https://hub.docker.com/_/archlinux).


## Setup

Before we can do anything, we need to create the directory on the host:
For consistency, we'll call it `/mnt/did`.

```bash
sudo mkdir /mnt/did
```

## Creating a Distro in a Directory (TM)

Let's start by running the image we want:

```bash
docker run --rm -it \
    --privileged \
    --mount type=bind,source=/mnt/did,target=/live \
    archlinux bash
```

With `--mount type=bind,source=/mnt/did,target=/live`, we're binding `/mnt/did` on the host to `/live` on the guest.
We need to use `--privileged` to allow `/live` to be remounted with `suid` for when we copy all the files.

One inside the image, the first step is to remount `/live` to remove `nosuid`.

```bash
mount -n -o remount,suid /live
```

Next, we copy the entire base system to the live location excluding any special mounts:

```bash
cp -xav / /live
```

## Next
[\[02: Pivoting Into a Running Distro\]](./02-pivoting.md)
