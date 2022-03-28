# 03: Migrate to Multi-user Mode

With the pivoted shell running inside your distro root, you're running Linux under single-user mode (i.e. the recovery shell).  
That's great for containerized programs, but not for an entire distro.

We're going to enter multi-user mode by starting the [init daemon](https://en.wikipedia.org/wiki/Init).

> **Warning:**  
> This guide is using Arch as a base distro.  
> If you're using another distro, you're going to have to adapt to the differences.


## Preparation

Before we start, we need to make a user for ourselves:

> **Tip:**  
> This guide will use the username `me`, but you're welcome to change it.

```
useradd --create-home --uid=1000 --user-group --password="$1$$fts6dWhynnCD9Px.kADTg1" me
```

Note that the password is hardcoded.

The `useradd` command doesn't actually hash the password, and `pam_unix` *expects* a hashed password.  
Rather than generate one now, we can use the hardcoded password for "`temp`" and change it later.

Now we should update `systemd` and install `sudo`:

```
pacman -Syu --noconfirm systemd sudo
```

You're going to see a bunch of warnings about "current root is not booted".  
This is fine, and will be fixed once we start systemd.
