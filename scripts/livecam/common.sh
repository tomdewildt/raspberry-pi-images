#!/bin/bash
set -eu -o pipefail

# Configure hostname
echo "$name.local" > /etc/hostname

# Configure fail2ban
mv -f /tmp/packer/fail2ban/* /etc/fail2ban/jail.d/
chmod 644 /etc/fail2ban/jail.d/*

# Configure rotation
mv -f /tmp/packer/logrotate/* /etc/logrotate.d/
chmod 644 /etc/logrotate.d/*
