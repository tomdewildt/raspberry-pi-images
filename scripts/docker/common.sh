#!/bin/bash
set -eu -o pipefail

# Configure hostname
echo "$name.local" > /etc/hostname
