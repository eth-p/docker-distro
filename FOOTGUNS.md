# Footguns

This is a list of footguns that I have encountered while setting up a distro in a Docker container.

Footguns marked with `(!)` are critical, and will cause problems if not addressed properly.


## Docker Volumes are Mounted With `nosuid` [fixable]

This will cause programs requiring [setuid(2)](https://man7.org/linux/man-pages/man2/setuid.2.html) to fail.
Common examples of such programs are,

- `unix_chkpwd`, a helper setuid binary that's used to check a user's prompted password. **(!)**  
  This is used for `ssh`, the `passwd` utility, and pretty much anything that requires a user password.
  
- `sudo`, that command you use to run stuff as root.

This can only be solved by remounting the filesystem with the `suid` option:

```bash
mount -n -o remount,suid /path/to/fs
```

## The `systemd-firstboot.service` will hang the init daemon [fixable]

This service will hang waiting for user input from the physical console, preventing system initialization.

Luckily, you can just diable it:


```bash
systemctl disable systemd-firstboot.service
```


## The `systemd-networkd-wait-online.service` will always timeout [workaround]

Whenever an installed service relies on `network-online.target`, the `systemd-networkd-wait-online.service` will be started.
This service will **never** complete, despite networking being online and available for both incoming and outbound connections.

The current solution to this is to just symlink the binary to `/bin/true`:

```bash
sudo mv /lib/systemd/systemd-networkd-wait-online /lib/systemd/systemd-networkd-wait-online.real
sudo ln -s /bin/true /lib/systemd/systemd-networkd-wait-online
```
