# docker-distro

A Docker image for pivoting the root and running the init daemon inside a Docker container.

## Requirements

At the bare minimum, this image requires `CAP_SYS_ADMIN` and `CAP_CHROOT` to pivot the root.
These capabilities can be provided with the following `docker run` flags:

```
--cap-add SYS_ADMIN
--cap-add CHROOT
```

Additionally, you need a mount point for your distro.
By default it should be mounted to `/live`, but you can change it by using `--root /path/to/your/mountpoint`:

```
--mount type=bind,source=/path/to/your/distro/files,target=/live
```


## Usage

Run a shell inside the distro root:

```bash
docker run -it --name "did" \
    --cap-add SYS_ADMIN \
    --cap-add CHROOT \
    --mount type=bind,source=/path/to/your/distro/files,target=/live \
    docker-distro --shell
```

Run the distro's init daemon:

```bash
docker run -it --name "did" \
    --cap-add SYS_ADMIN \
    --cap-add CHROOT \
    --mount type=bind,source=/path/to/your/distro/files,target=/live \
    docker-distro
```
