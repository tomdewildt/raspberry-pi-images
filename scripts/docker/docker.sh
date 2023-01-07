#!/bin/bash
set -eu -o pipefail

# Install dependencies
apt-get install -y ca-certificates curl gnupg lsb-release

# Add key
mkdir -m 755 /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod 644 /etc/apt/keyrings/docker.gpg

# Add repository
cat <<EOF > /etc/apt/sources.list.d/docker.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable
EOF
chmod 644 /etc/apt/sources.list.d/docker.list

# Install packages
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Configure docker
usermod -aG docker $username
