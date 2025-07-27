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

echo "Copying custom scripts..."
install -m 0755 /ctx/firstboot/setup-intel-graphics.sh /usr/local/bin/setup-intel-graphics.sh
install -m 0755 /ctx/firstboot/setup-user.sh /usr/local/bin/setup-user.sh

echo "Running graphics optimisation script..."
/usr/local/bin/setup-intel-graphics.sh
/usr/local/bin/setup-user.sh

dnf5 install -y tmux 

systemctl enable podman.socket
