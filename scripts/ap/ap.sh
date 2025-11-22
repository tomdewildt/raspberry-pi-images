#!/bin/bash
set -eu -o pipefail

# Update repositories
apt-get update

# Install packages
apt-get install -y hostapd dnsmasq bridge-utils

# Stop services
systemctl stop hostapd
systemctl stop dnsmasq

# Disable conflicting managers
if systemctl is-enabled --quiet dhcpcd; then
  systemctl disable --now dhcpcd
fi
if systemctl list-unit-files | grep -q NetworkManager.service; then
  systemctl disable --now NetworkManager || true
fi

# Configure interfaces
if [ -f /etc/dhcpcd.conf ]; then
  mv /etc/dhcpcd.conf /etc/dhcpcd.conf.bak.$(date +%s) || true
fi
cat <<EOF >/etc/network/interfaces
auto lo
iface lo inet loopback

auto br0
iface br0 inet static
    address $network_gateway_ip
    netmask $network_subnet_mask
    bridge_ports eth0
    bridge_stp off
    bridge_fd 0

allow-hotplug eth0
iface eth0 inet manual

allow-hotplug wlan0
iface wlan0 inet manual
EOF

# Configure hostapd
cat <<EOF >/etc/hostapd/hostapd.conf
country_code=NL
interface=wlan0
bridge=br0
ssid=$network_name
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1

auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=$network_password
EOF
sed -i 's|^#\?DAEMON_CONF=.*|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

# Configure dnsmasq
if [ -f /etc/dnsmasq.conf ]; then
  mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak.$(date +%s)
fi
cat <<EOF >/etc/dnsmasq.conf
interface=br0
bind-interfaces

dhcp-range=$dhcp_range_start,$dhcp_range_end,$network_subnet_mask,24h
dhcp-option=3,$network_gateway_ip
dhcp-option=6,$network_gateway_ip
EOF

# Enable services
systemctl unmask hostapd || true
systemctl enable hostapd
systemctl enable dnsmasq
