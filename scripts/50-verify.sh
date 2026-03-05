#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/00-env"

echo "[+] Service status"
systemctl status samba-ad-dc --no-pager || true

echo "[+] Port 53 (DNS) listening?"
ss -lpun | grep ':53' || true

zone="$(echo "${REALM}" | tr '[:upper:]' '[:lower:]')"

echo "[+] LDAP SRV record:"
host -t SRV _ldap._tcp.${zone} 127.0.0.1 || true

echo "[+] Kerberos SRV records:"
host -t SRV _kerberos._udp.${zone} 127.0.0.1 || true
host -t SRV _kerberos._tcp.${zone} 127.0.0.1 || true

echo "[+] Internet forward lookup via local DNS:"
host ubuntu.com 127.0.0.1 || true

echo "[+] AD users:"
samba-tool user list || true