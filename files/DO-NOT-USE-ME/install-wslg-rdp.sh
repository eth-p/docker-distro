#!/usr/bin/env bash
set -euo pipefail

# Enter sudo to cache `sudo` status for a while.
sudo true || {
    echo "Please enter sudo."
    exit 1
}

# Sync dependencies.
printf "\x1B[34m=> Installing dependencies...\x1B[0m\n"
(cd "ms-weston" && makepkg --syncdeps --noextract --nobuild --noconfirm)
(cd "ms-freerdp" && makepkg --syncdeps --noextract --nobuild --noconfirm)

# Uninstall upstream FreeRDP.
printf "\x1B[34m=> Uninstalling upstream dependencies...\x1B[0m\n"
sudo pacman -R --noconfirm freerdp

# Install packages.
printf "\x1B[34m=> Compiling Microsoft forks...\x1B[0m\n"
(cd "ms-freerdp" && makepkg -fi)
(cd "ms-weston" && makepkg -fi)

# Pin packages.
printf "\x1B[34m=> Pinning packages...\x1B[0m\n"
{
    echo "[options]"
    echo "IgnorePkg = freerdp"
    echo "IgnorePkg = weston"
} | sudo tee -a /etc/pacman.conf >/dev/null
