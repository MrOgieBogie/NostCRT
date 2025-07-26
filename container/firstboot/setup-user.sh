#!/usr/bin/env bash
set -e

USERNAME="CRT"
PASSWORD="Nostalgia"

if ! id "$USERNAME" &>/dev/null; then
  useradd -m -s /bin/bash "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd
  usermod -aG wheel "$USERNAME"
fi
