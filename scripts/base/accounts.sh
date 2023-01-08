#!/bin/bash
set -eu -o pipefail

# Install packages
apt-get install -y sudo

# Configure user
useradd -m -s /bin/bash -G sudo $username
echo "$username:$password" | chpasswd

# Disable root
passwd -l root
