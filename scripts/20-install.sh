#!/usr/bin/env bash
set -euo pipefail

echo "[+] Updating apt"
apt update

echo "[+] Installing packages"
apt install -y samba samba-ad-dc winbind krb5-user smbclient dnsutils chrony

echo "[+] Disabling standalone services (must not run on AD DC)"
systemctl disable --now smbd nmbd winbind 2>/dev/null || true
pkill smbd nmbd winbindd 2>/dev/null || true
rm -f /run/samba/*.pid || true

echo "[+] Disabling systemd-resolved (common lab setup for Samba internal DNS)"
systemctl disable --now systemd-resolved || true
rm -f /etc/resolv.conf || true

echo "[+] Temporary resolv.conf (public DNS) for package installs"
cat >/etc/resolv.conf <<'EOF'
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

echo "[+] Done."