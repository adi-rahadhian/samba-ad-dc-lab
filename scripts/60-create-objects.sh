#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/00-env"

echo "[+] Creating OUs (ignore if already exist)"
samba-tool ou create "${OU_USERS}" 2>/dev/null || true
samba-tool ou create "${OU_WORKSTATIONS}" 2>/dev/null || true

echo "[+] Creating user: ${NEW_USER}"
if [ -z "${NEW_USER_PASSWORD}" ]; then
  samba-tool user create "${NEW_USER}" \
    --given-name="${NEW_USER_GIVEN}" \
    --surname="${NEW_USER_SURNAME}" \
    --must-change-at-next-login
else
  samba-tool user create "${NEW_USER}" "${NEW_USER_PASSWORD}" \
    --given-name="${NEW_USER_GIVEN}" \
    --surname="${NEW_USER_SURNAME}" \
    --must-change-at-next-login
fi

echo "[+] Done."