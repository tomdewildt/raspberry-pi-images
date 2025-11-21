#!/bin/bash
set -eu -o pipefail

# Update repositories
apt-get update

# Install packages
apt-get install -y network-manager dnsmasq

# Create configuration directory
mkdir -p /etc/NetworkManager/system-connections

# Configure bridge connection
cat <<EOF > /etc/NetworkManager/system-connections/bridge.nmconnection
[connection]
id=bridge
type=bridge
interface-name=bridge0
autoconnect=true
autoconnect-priority=100

[bridge]
stp=false

[ipv4]
method=manual
address1=$network_gateway_ip/24
gateway=$network_gateway_ip

[ipv6]
method=disabled
EOF
chmod 600 /etc/NetworkManager/system-connections/bridge.nmconnection

# Configure ethernet connection
cat <<EOF > /etc/NetworkManager/system-connections/ethernet.nmconnection
[connection]
id=ethernet
type=ethernet
interface-name=eth0
autoconnect=true
autoconnect-priority=50
master=bridge0
slave-type=bridge

[ethernet]
EOF
chmod 600 /etc/NetworkManager/system-connections/ethernet.nmconnection

# Configure hotspot connection
cat <<EOF > /etc/NetworkManager/system-connections/hotspot.nmconnection
[connection]
id=hotspot
type=wifi
interface-name=wlan0
autoconnect=true
autoconnect-priority=50
master=bridge0
slave-type=bridge

[wifi]
mode=ap
ssid=$network_name

[wifi-security]
key-mgmt=wpa-psk
proto=rsn
pairwise=ccmp
psk=$network_password

[ipv4]
method=disabled

[ipv6]
method=disabled
EOF
chmod 600 /etc/NetworkManager/system-connections/hotspot.nmconnection

# Configure dnsmasq
cat <<EOF > /etc/dnsmasq.d/bridge.conf
interface=bridge0
dhcp-range=$dhcp_range_start,$dhcp_range_end,$network_subnet_mask,24h
dhcp-option=3,$network_gateway_ip
dhcp-option=6,$network_gateway_ip
port=0
EOF

# Enable services
systemctl enable NetworkManager
systemctl enable dnsmasq
