# Extra: GPU Acceleration (Nvidia)

> **Warning:**  
> This section is a work-in-progress.

> **Acknowledgement:**
> This would not be possible without the great work of the [docker-nvidia-glx-desktop](https://github.com/ehfd/docker-nvidia-glx-desktop) project.
> Thanks to them for helping me figure out how to configure everything!

If, for some reason (like Steam Remote Play), you want to have GPU acceleration with a full X server and display, that's possible with an NVIDIA GPU.

## Host Setup

TODO Guide:

- Install NVIDIA kernel drivers
- Install NVIDIA plugin for Docker
- Add `--gpus` and the environment variables to the container.

## Container Setup: NVIDIA Drivers

With the kernel drivers installed, it's time to install the usermode libraries required to interact with the graphics card.
The Docker plugin will include all libraries necessary for headless OpenGL or compute, but it doesn't include the libraries we need to start an X server.

To fix that, we're going to pull the official package from the internet and install the missing libraries.  
From within a pivoted container, run the following script:

```bash
sudo /boot/container/extra/decapx/scripts/decapx-update-nvidia
```

Once that's done, we should enable the `systemd` service to ensure that the drivers stay up to date:

```bash
systemctl enable /boot/container/extra/decapx/systemd/decapx-drivers.service
```

## Container Setup: Xorg Server

The next step is to configure X to use a real-but-fake display output from the graphics card.

To keep the explanation brief, in order to capture video output and stream it, a real port on the GPU needs to be used as a framebuffer. We tell X to use the first DisplayPort output on the graphics card, and then change some settings to ensure that it doesn't complain about a real monitor not being connected.

Enable the following `systemd` services:

```bash
systemctl enable /boot/container/extra/decapx/systemd/decapx-xorg.service
systemctl enable /boot/container/extra/decapx/systemd/decapx-xorg-wait-for-startup.path
systemctl enable /boot/container/extra/decapx/systemd/decapx-xorg-wait-for-startup.service

# Or, in one line:
sudo bash -c 'printf "%s\n" /boot/container/extra/decapx/systemd/decapx-xorg* | xargs -I{} systemctl enable {}'
```

These services will automatically configure and start the X server on boot.

## Container Setup: Desktop Environment

TODO Guide:

- Install `sunshine` (for remote control)
    - Requires bind-mounting host `/dev/input` for udev rules.
    - Requires `systemd` service to start it up after `decapx-xorg-wait-for-startup.service`
- Install KDE `plasma`
    - Requires `systemd` service to start it up after `decapx-xorg-wait-for-startup.service`
    - Requires `/etc/fstab` change to make `/dev/shm` *a lot* larger than 64 KiB.
        - If this isn't done, Chrome will misbehave.
        - Chrome misbehaving means CEF misbehaves, meaning Steam doesn't work.

**End result:** Steam Remote Play
