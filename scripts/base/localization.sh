#!/bin/bash
set -eu -o pipefail

# Install packages
apt-get install -y locales

# Generate locale
sed -i "/$locale/s/^# //g" /etc/locale.gen
locale-gen

# Configure locale
update-locale LC_ALL=$locale LANG=$locale

# Configure time
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
