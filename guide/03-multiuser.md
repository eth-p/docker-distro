# 03: Migrate to Multi-user Mode

With the pivoted shell running inside your distro root, you're running Linux under single-user mode (i.e. the recovery shell).  
That's great for containerized programs, but not for an entire distro.

We're going to enter multi-user mode by starting the [init daemon](https://en.wikipedia.org/wiki/Init).

> **Warning:**  
> This guide is using Arch as a base distro, where the init daemon is provided by `systemd`.  
> If you're using another distro, you're going to have to adapt to the differences.


## Preparation

### Make yourself a user.

Before we start, we need to make a user for ourselves:

> **Tip:**  
> This guide will use the username `me`, but you're welcome to change it.

```bash
useradd --create-home --uid=1000 --user-group --password='$1$$fts6dWhynnCD9Px.kADTg1' me
```

Note that the password is hardcoded.

The `useradd` command doesn't actually hash the password, and `pam_unix` *expects* a hashed password.  
Rather than generate one now, we can use the hardcoded password for "`temp`" and change it later.

### Install and set up sudo.

With our user done, we need to install sudo:

```bash
pacman -S --noconfirm sudo
```

Then create the `sudo` group, enable it in `/etc/sudoers`, and add yourself to it:

```bash
groupadd --system sudo
sed 's/^# %sudo/%sudo/' -i.bak /etc/sudoers
usermod -a -G sudo me
```

### Update systemd.

Finally, we should update `systemd` before we enter multi-user mode:

```bash
pacman -Syu --noconfirm systemd
```

You're going to see a bunch of warnings about "current root is not booted".  
This is fine, and will be fixed once we start systemd.


## The Init Daemon

With everything set up and ready, it's time to run the `init` daemon.
The init daemon is responsible for setting up system services, handling orphaned processes, and starting the daemons necessary to run multi-user system.

First, let's make sure that the current PID is 1 (init):

```console
$ echo $$
1
```

If the PID is 1, we can `exec /sbin/init` to replace our running shell with the init daemon:

```bash
exec /sbin/init
```

> **Note:**  
> Once `init` is started, you will not be able to CTRL+C out of `docker run`.
> Further work should be done through `docker exec -it did` (or whichever container name).

> **Tip:**  
> Want to shut down the container?
> From a root shell (inside the container), run `shutdown now` to shut down systemd and stop the container.
