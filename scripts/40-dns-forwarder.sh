#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/00-env"

echo "[+] Setting dns forwarder in smb.conf to ${DNS_FORWARDER}"
# Remove duplicate dns forwarder lines
sed -i '/^\s*dns forwarder\s*=.*/d' /etc/samba/smb.conf

# Insert under [global]
awk -v fwd="    dns forwarder = ${DNS_FORWARDER}" '
  BEGIN{done=0}
  /^\[global\]/{print; if(!done){print fwd; done=1; next}}
  {print}
' /etc/samba/smb.conf > /tmp/smb.conf && mv /tmp/smb.conf /etc/samba/smb.conf

echo "[+] Restarting samba-ad-dc"
systemctl restart samba-ad-dc

echo "[+] Done."