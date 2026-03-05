#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/00-env"

echo "[+] Setting hostname to ${DC_FQDN}"
hostnamectl set-hostname "$DC_FQDN"

echo "[+] Ensuring /etc/hosts maps FQDN -> ${DC_IP}"
# Remove any 127.0.1.1 mapping for the FQDN if present
sed -i "/[[:space:]]${DC_FQDN}\b/d" /etc/hosts || true

# Ensure base lines exist
grep -qE '^127\.0\.0\.1\s+localhost' /etc/hosts || echo "127.0.0.1 localhost" >> /etc/hosts

# Add correct mapping
if ! grep -qE "^${DC_IP}[[:space:]]+${DC_FQDN}\b" /etc/hosts; then
  echo "${DC_IP}  ${DC_FQDN} ${DC_HOST}" >> /etc/hosts
fi

echo "[+] Done. Current host:"
hostnamectl