#!/bin/bash
set -eu -o pipefail

# Install package
apt-get install -y logrotate

# Configure logging
echo "kernel.printk = 3 4 1 3" > /etc/sysctl.d/10-configure-logging.conf

# Configure rotation
mv -f /tmp/packer/logrotate/* /etc/logrotate.d/
chmod 644 /etc/logrotate.d/*
