#!/usr/bin/env bash
set -oue pipefail

echo "[🔧 Firstboot] Running initial setup..."

# Move firstboot scripts into place
install -m 0755 /var/firstboot/setup-intel-graphics.sh /usr/local/bin/setup-intel-graphics.sh
install -m 0755 /var/firstboot/setup-user.sh /usr/local/bin/setup-user.sh

# Optionally run the Intel graphics script on first boot
/usr/local/bin/setup-intel-graphics.sh

# Remove the systemd unit so it doesn't run again
systemctl disable firstboot-setup.service
rm -f /etc/systemd/system/firstboot-setup.service
