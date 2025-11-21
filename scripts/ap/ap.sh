#!/bin/bash
set -eu -o pipefail

# Install packages
apt-get update
apt-get install -y network-manager dnsmasq

# Stop services
systemctl stop NetworkManager
systemctl stop dnsmasq

# Configure network manager
nmcli connection add type bridge con-name 'bridge' ifname bridge0 \
    ipv4.method manual \
    ipv4.addresses "$network_gateway_ip/24" \
    ipv4.gateway "$network_gateway_ip"
nmcli connection add type ethernet slave-type bridge con-name 'ethernet' ifname eth0 master bridge0
nmcli connection add con-name 'hotspot' \
    ifname wlan0 type wifi slave-type bridge master bridge0 \
    wifi.mode ap wifi.ssid "$network_name" wifi-sec.key-mgmt wpa-psk \
    wifi-sec.proto rsn wifi-sec.pairwise ccmp \
    wifi-sec.psk "$network_password"

# Set connections to autoconnect
nmcli connection modify 'bridge' connection.autoconnect yes
nmcli connection modify 'ethernet' connection.autoconnect yes
nmcli connection modify 'hotspot' connection.autoconnect yes

# Set the connection priority to ensure proper startup order
nmcli connection modify 'bridge' connection.autoconnect-priority 100
nmcli connection modify 'ethernet' connection.autoconnect-priority 50
nmcli connection modify 'hotspot' connection.autoconnect-priority 50

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

# Start network manager
systemctl start NetworkManager
sleep 5

# Bring up the bridge and connections
nmcli connection up 'bridge'
nmcli connection up 'hotspot'
sleep 3

# Start dnsmasq
systemctl start dnsmasq
