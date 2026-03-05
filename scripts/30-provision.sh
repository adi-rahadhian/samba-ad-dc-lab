#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/00-env"

echo "[+] Backing up existing smb.conf (if any)"
if [ -f /etc/samba/smb.conf ]; then
  mv /etc/samba/smb.conf "/etc/samba/smb.conf.bak.$(date +%F_%H%M%S)" || true
fi

echo "[+] Provisioning domain: REALM=${REALM} DOMAIN=${DOMAIN}"
samba-tool domain provision \
  --use-rfc2307 \
  --realm="${REALM}" \
  --domain="${DOMAIN}" \
  --server-role=dc \
  --dns-backend=SAMBA_INTERNAL

echo "[+] Installing Samba Kerberos config"
cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf

echo "[+] Enabling samba-ad-dc"
systemctl enable --now samba-ad-dc

echo "[+] Switching resolv.conf to local Samba DNS"
cat >/etc/resolv.conf <<EOF
nameserver 127.0.0.1
search $(echo "${REALM}" | tr '[:upper:]' '[:lower:]')
EOF

echo "[+] Done."