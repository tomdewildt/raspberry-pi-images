#!/bin/bash
set -eu -o pipefail

# Install packages
apt-get install -y fail2ban ufw unattended-upgrades

# Configure firewall
sed -i "/IPV6=/c\IPV6=no" /etc/default/ufw
sed -i "/DEFAULT_INPUT_POLICY=/c\DEFAULT_INPUT_POLICY=\"DROP\"" /etc/default/ufw
sed -i "/DEFAULT_OUTPUT_POLICY=/c\DEFAULT_OUTPUT_POLICY=\"ACCEPT\"" /etc/default/ufw
sed -i "/DEFAULT_FORWARD_POLICY=/c\DEFAULT_FORWARD_POLICY=\"DROP\"" /etc/default/ufw
sed -i "/DEFAULT_APPLICATION_POLICY=/c\DEFAULT_APPLICATION_POLICY=\"SKIP\"" /etc/default/ufw
sed -i "/ENABLED=/c\ENABLED=yes" /etc/ufw/ufw.conf
sed -i "/### RULES ###/a ### END RULES ###" /etc/ufw/user.rules

# Fix firewall (not initializing correctly)
cat <<EOF > /etc/rc.local
#!/bin/bash
ufw reload
rm \$0
EOF
chmod 755 /etc/rc.local

# Configure fail2ban
mv -f /tmp/packer/fail2ban/* /etc/fail2ban/jail.d/
chmod 644 /etc/fail2ban/jail.d/*

# Configure unattended upgrades
mv -f /tmp/packer/unattended-upgrades/* /etc/apt/apt.conf.d/
chmod 644 /etc/apt/apt.conf.d/*
