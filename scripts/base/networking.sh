#!/bin/bash
set -eu -o pipefail

# Configure hostname
echo "$name.local" > /etc/hostname

# Configure network
cat <<EOF > /etc/network/interfaces.d/eth0
auto eth0
allow-hotplug eth0

iface eth0 inet dhcp
EOF

# Disable IPv6
cat <<EOF > /etc/sysctl.d/10-disable-ipv6.conf
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1

net.ipv6.conf.lo.disable_ipv6=1
net.ipv6.conf.eth0.disable_ipv6=1
net.ipv6.conf.wlan0.disable_ipv6=1
EOF
