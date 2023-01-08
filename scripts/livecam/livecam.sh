#!/bin/bash
set -eu -o pipefail

# Install package
apt-get install -y apache2-utils gettext motion nginx

# Configure motion
rm -f /etc/motion/*-dist.conf
envsubst "\$camera_name,\$camera_width,\$camera_height,\$camera_fps,\$camera_quality" < /tmp/packer/motion/motion.conf > /etc/motion/motion.conf
chown root:root /etc/motion/motion.conf
chmod 644 /etc/motion/motion.conf
mkdir /var/log/motion
chown motion:motion /var/log/motion
chmod 755 /var/log/motion

# Configure nginx
sed -i "/### RULES ###/r /tmp/packer/ufw/http.rule" /etc/ufw/user.rules
sed -i "/### RULES ###/r /tmp/packer/ufw/https.rule" /etc/ufw/user.rules
envsubst "\$name\$address" < /tmp/packer/nginx/default > /etc/nginx/sites-available/default
chmod 644 /etc/nginx/sites-available/default
touch /etc/nginx/.htpasswd
chmod 644 /etc/nginx/.htpasswd

# Configure html
rm -f /var/www/html/*.html
envsubst "\$camera_name,\$camera_width,\$camera_height,\$camera_fps,\$camera_quality" < /tmp/packer/nginx/html/index.html > /var/www/html/index.html
chmod 644 /var/www/html/*
rm -f /usr/share/nginx/html/*.html
mv -f /tmp/packer/nginx/html/*0x.html /usr/share/nginx/html
chmod 644 /usr/share/nginx/html/*
