#!/usr/bin/env bash
set -euo pipefail

# Enter sudo to cache `sudo` status for a while.
sudo true || {
    echo "Please enter sudo."
    exit 1
}

# Sync dependencies.
(cd "ms-weston" && makepkg --syncdeps --noextract --nobuild --noconfirm)
(cd "ms-freerdp" && makepkg --syncdeps --noextract --nobuild --noconfirm)

# Install packages.
(cd "ms-freerdp" && makepkg -fi)
(cd "ms-weston" && makepkg -fi)
