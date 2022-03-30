# 04: Basic Command-Line Setup

> **Warning:**  
> This section is only relevant to Arch Linux.  
> If you're using another distro, you're going to have a different experience.

At this point, you should have a minimal headless distro running.
To get the most (or rather, least) out of your system, some more packages are going to need to be installed.


## Preparation

In the last section, we installed an SSH server on our distro.
Let's use it to log in!

If you don't remember what your password was, it should be "`temp`".

```console
$ ssh me@10.250.0.1
The authenticity of host '10.250.0.1 (10.250.0.1)' can't be established.
ECDSA key fingerprint is SHA256:u5Eublp/mWd3lql0gFA0A1CvbpGx4P9TVUYQSDP3OuU.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.250.0.1' (ECDSA) to the list of known hosts.
me@10.250.0.1's password:

Last login: Wed Mar 30 01:50:35 2022 from 127.0.0.1
[me@47ba0528cd3c ~]$ 
```

## Remove NoExtract

The default `archlinux` image we based our distro off of comes with a `pacman` config that stops files from being extracted to certain paths.
This includes manual pages, localizations, and documentation.

If you want these, run the following commands:

```bash
sudo sed -i '/^NoExtract/d' /etc/pacman.conf
sudo bash -c 'pacman -Qqn | pacman -S --noconfirm -'  # <-- reinstalls all packages
```

## Coreutils

These programs come standard with most full distros:

```bash
sudo pacman -S --noconfirm \
    coreutils \
    which \
    man man-pages \
    wget
```

## Build Essentials

These programs are used to compile most POSIX software:

```bash
sudo pacman -S --noconfirm \
    make autoconf automake \
    pkgconfig fakeroot \
    gcc
```
