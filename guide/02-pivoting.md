# 02: Pivoting Into a Running Distro

Now that we have a Distro in a Directory (TM), we need to interact with it.

Rather than going through a `chroot` jail, we're going to pivot the root to your distro.  
Fun fact: this is how initramfs transitions to the real root.

The way this works is by using the [pivot_root(2) syscall](https://man7.org/linux/man-pages/man2/pivot_root.2.html).  
In simple terms, it _swaps_ the `/` mountpoint of the calling process (the container) with another one (our distro).

> **Noob tip:**  
> If you want to skip this step, you can use [docker-distro-init](./files/dockerfiles/docker-distro-init) docker image.
> Just make sure to follow the instructions to ensure it has the correct permissions and bind mount!


## Pivoting

For this, we're going to use an [Alpine](https://hub.docker.com/_/alpine) image due to its small file size.  

Later on, we'll need to `docker exec` into the container, so make sure you name it, bind mount `/mnt/did`, and provide the correct privileges!  
This guide will use the name `did` for consistency.

> **Required Privileges:**
> - Full privileges.
> - Even more privileges.
> - No reboot privileges (it would be bad to shutdown the host).

Let's create the container with those requirements:

```bash
docker run -it --name "did" \
    --privileged --security-opt="no-new-privileges:false" --cap-add ALL --cap-drop SYS_BOOT \
    --mount type=bind,source=/mnt/did,target=/live \
    alpine
```

You should now be dropped into a POSIX-compliant shell. Let's remount `/live` again:

```bash
mount -n -o remount,suid /live
```

With that fixed, we need to provide `/sys`, `/dev`, `/proc`, etc. to the soon-to-be-root.
You can do this manually by looking through `/proc/mounts`, or you can run the following script:

```bash
awk '{ print $2 }' /proc/mounts \
    | grep -v '^/$' | grep -v '^/live$' \
    | xargs -i{} mount --bind "{}" "/live{}"
```

Now we're ready to change the root to our distro!  
The [pivot_root](https://linux.die.net/man/8/pivot_root) tool is going to help us with that.

Essentially, `pivot_root $1 $2` changes cgroups to change the "root" namespace to "$1", while placing the old root inside `$2`.
In a typical initramfs the old root would be unmounted, but we can't do that because Docker is still using it.

```bash
mkdir /live/boot/container
pivot_root /live /live/boot/container
```

If `pivot_root` runs successfully, you will now be running your distro in single-user mode.  

```console
$ cat /etc/os-release
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
ID=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://archlinux.org/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://bbs.archlinux.org/"
BUG_REPORT_URL="https://bugs.archlinux.org/"
LOGO=archlinux-logo
```

Great!

## Next
[\[03: Migrate to Multi-user Mode\]](./03-multiuser.md)
