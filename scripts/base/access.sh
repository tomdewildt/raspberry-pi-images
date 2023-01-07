#!/bin/bash
set -eu -o pipefail

# Configure key
mkdir -m 700 /home/$username/.ssh
echo $pubkey > /home/$username/.ssh/authorized_keys
chmod 600 /home/$username/.ssh/authorized_keys
chown -R $username:$username /home/$username/.ssh

# Configure ssh
sed -i "/### RULES ###/r /tmp/packer/ufw/ssh.rule" /etc/ufw/user.rules
mv -f /tmp/packer/ssh/sshd_config /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config

# Disable banner
rm /etc/issue /etc/issue.net

# Configure motd
mv /tmp/packer/motd/update-motd.d/* /etc/update-motd.d/
chmod 755 /etc/update-motd.d/*
mv /tmp/packer/motd/motd /etc/motd
chmod 644 /etc/motd
