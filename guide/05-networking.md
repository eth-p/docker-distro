# 05: Networking Goodies

> **Warning:**  
> This section is only relevant to Arch Linux.  
> If you're using another distro, you're going to have a different experience.

Next up, you're probably going to want to set up some basic networking like NetBIOS and Multicast DNS.
These will let you connect to your distro with a hostname like `docker-distro.local`.


## Multicast DNS (mDNS)

Multicast DNS is built in to Systemd directly.
You just need to tweak a couple settings to enable it.

First, enable `MulticastDNS` in `/etc/systemd/resolved.conf`:

```
sudo sed -i 's/^#MulticastDNS/MulticastDNS/' /etc/systemd/resolved.conf
```

Next, create a `.network` file for your `eth0` network:

```bash
cat > /etc/systemd/network/eth0.network <<<EOF
[Match]
Name=eth0

[Network]
MulticastDNS=yes
DHCP=yes
LinkLocalAddressing=yes

EOF
```

## NetBIOS

To enable NetBIOS, you will need to install Samba and enable the `nmb` service:

```bash
sudo pacman -S --noconfirm samba
sudo systemctl enable nmb.service
sudo systemctl start nmb.service
```

