# 03: Migrate to Multi-user Mode

With the pivoted shell running inside your distro root, you're running Linux under single-user mode (i.e. the recovery shell).  
That's great for containerized programs, but not for an entire distro.

We're going to enter multi-user mode by starting the [init daemon](https://en.wikipedia.org/wiki/Init).

> **Warning:**  
> This guide is using Arch as a base distro, where the init daemon is provided by `systemd`.  
> If you're using another distro, you're going to have to adapt to the differences.


## Preparation

Before we can run `/sbin/init` and enter multi-user mode, there's a couple of steps we need to take care of. 

### Update the package databases.

First and foremost, we're going to want to update the package databases so we can install and update software.
On Arch, this can be done by running:

```bash
pacman -Sy --noconfirm
```

If everything went well, you should she the following in your terminal:

```
:: Synchronizing package databases...
 core downloading...
 extra downloading...
 community downloading...
 ```

### Update the distro packages.

With the package databases updated, it's now possible to update the packages that came with the `archlinux` image that your distro was based off of:

```bash
pacman -Su --noconfirm
```

### Disable systemd-firstboot service.

Now that everything is updated, we need to make some changes to ensure systemd runs smoothly.

On first boot, the `systemd-firstboot.service` will try to initialize the system with user-provided input.
Since we're running `systemd` inside docker without a physical console, it effectively just locks the init daemon and prevents it from working.

Luckily, you can just disable the service with no ill effects:

```bash
systemctl disable systemd-firstboot.service
```

### Make yourself a user.

At this point, you could start `/sbin/init`. You can't really _do_ anything without a user, though.
Let's create one!

> **Tip:**  
> This guide will use the username `me`, but you're welcome to change it.

```bash
useradd --create-home --uid=1000 --user-group --password='$1$$fts6dWhynnCD9Px.kADTg1' me
install -d -o me /run/user/`id -u me`
```

Note that the password is hardcoded.

The `useradd` command doesn't actually hash the password, and `pam_unix` *expects* a hashed password.  
Rather than generate one now, we can use the hardcoded password for "`temp`" and change it later.


### Install and set up sudo.

With our user created, we need to install the sudo command:

```bash
pacman -S --noconfirm sudo
```

Unfortunately, we won't be able to use the newly-installed sudo command just yet.
We need to configure sudo to see our user as someone allowed to sudo.

To do this, we're going to create a `sudo` group, enable it in `/etc/sudoers`, and add our user to it:

```bash
groupadd --system sudo
sed 's/^# %sudo/%sudo/' -i.bak /etc/sudoers
usermod -a -G sudo me
```

### Install and set up openssh server.

Due to the login initialization steps taken by systemd, `su - me` isn't sufficient for logging in as your user. 
We're going to need to install a SSH server:

```bash
pacman -S --noconfirm openssh
systemctl enable sshd.service
```

While we're at it, let's grab our IP address for later:

```console
$ ip addr | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
    inet 10.250.0.1/24 brd 10.250.0.255 scope global eth0
    inet6 2001:569:7d4a:9a00:42:aff:fefa:1/64 scope global dynamic mngtmpaddr
    inet6 2001:569:7d4a:9a00::2/64 scope global nodad
    inet6 fe80::42:aff:fefa:1/64 scope link
```

In my case, the container's IP address is `10.250.0.1`.


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

Once the `init` daemon has finished, it should show you a login screen:

```
Arch Linux 5.10.28-Unraid (console)

47ba0528cd3c login:
```

If you see something along those lines, then you have a working minimal headless distro.
Congrats!

> **Note:**  
> Once `init` is started, you will not be able to CTRL+C out of `docker run`.
> Further work should be done through `docker exec -it did` (or whichever container name).

> **Tip:**  
> Want to shut down the container?
> From a root shell (inside the container), run `shutdown now` to shut down systemd and stop the container.


## Next
[\[04: Migrate to Multi-user Mode\]](./03-multiuser.md)
