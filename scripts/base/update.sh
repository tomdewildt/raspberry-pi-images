#!/bin/bash
set -eu -o pipefail

# Update repositories
apt-get -y update

# Upgrade packages
apt-get -y upgrade
apt-get -y dist-upgrade
