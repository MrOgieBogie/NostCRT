#!/bin/bash

set -ouex pipefail

# Check that /mnt is mounted and has enough space, or skip if not mounted
if mountpoint -q /mnt; then
  AVAILABLE=$(df --output=avail /mnt | tail -n1)
  if [ "$AVAILABLE" -lt 1048576 ]; then # ~1GB in KB
    echo "Not enough space on /mnt. Available: $AVAILABLE KB"
    exit 1
  fi
else
  echo "/mnt is not mounted. Skipping /mnt checks."
fi

### Install packages
set -oue pipefail

echo "Copying firstboot scripts..."
mkdir -p /var/firstboot
install -m 0755 /ctx/firstboot/setup-intel-graphics.sh /var/firstboot/setup-intel-graphics.sh
install -m 0755 /ctx/firstboot/setup-user.sh /var/firstboot/setup-user.sh

echo "Installing firstboot systemd service and runner..."
install -m 0755 /ctx/firstboot/firstboot.sh /usr/local/bin/firstboot.sh
install -m 0644 /ctx/firstboot/firstboot-setup.service /etc/systemd/system/firstboot-setup.service

echo "Enabling firstboot service..."
systemctl enable firstboot-setup.service

dnf5 install -y tmux 

systemctl enable podman.socket
