## Troubleshooting common issues

Below is a list of issues you might encounter when provisioning or managing a Samba Active Directory DC, along with their causes and solutions.

### `samba-ad-dc` fails to start (smbd already running)

**Symptoms:** `systemctl status samba-ad-dc` shows `smbd child process exited`, and `/run/samba/smbd.pid` exists.

**Cause:** The standalone `smbd`, `nmbd`, or `winbind` services are still running, which conflicts with the AD DC process.

**Fix:**
```bash
sudo systemctl disable --now smbd nmbd winbind
sudo pkill smbd nmbd winbindd
sudo rm -f /run/samba/*.pid
sudo systemctl restart samba-ad-dc
```

### Missing `winbindd` binary

**Symptoms:** logs contain `winbindd: Failed to exec child - No such file or directory`.

**Cause:** The `winbind` package isn’t installed.

**Fix:**
```bash
sudo apt install -y winbind
sudo systemctl restart samba-ad-dc
```

### `apt update` fails with Ign/Err: cannot resolve names

**Cause:** `/etc/resolv.conf` points to `127.0.0.1` while the Samba DNS service isn’t up yet.

**Fix:** Temporarily set public DNS servers until Samba DNS is running, then revert to `127.0.0.1` with a forwarder in `smb.conf`:

```bash
# temporary resolv.conf
echo -e "nameserver 1.1.1.1\nnameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# after DNS up
echo -e "nameserver 127.0.0.1\nsearch test.local" | sudo tee /etc/resolv.conf
```

### `kinit`: Cannot find KDC for realm

**Symptoms:** `kinit` fails with “Cannot find KDC for realm” or “Client not found”.

**Cause:** Kerberos SRV records are missing or `krb5.conf` is incorrect.

**Fix:**
```bash
sudo cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf
host -t SRV _kerberos._udp.test.local 127.0.0.1
sudo samba_dnsupdate --verbose
sudo systemctl restart samba-ad-dc
```
Ensure `/etc/resolv.conf` points to `127.0.0.1` and the DNS forwarder is an external server (e.g., `9.9.9.9`).

### DNS forwarder loops

**Symptoms:** External domain lookups fail while `samba-ad-dc` is running; the DNS log shows repeated queries.

**Cause:** `dns forwarder` in `smb.conf` is set to `127.0.0.1` (looping back to itself).

**Fix:** Set `dns forwarder` to a public DNS (e.g., `9.9.9.9`, `1.1.1.1`) under the `[global]` section of `smb.conf`, then restart Samba.

### Using `.local` domain

**Note:** macOS and some Linux hosts use `.local` for mDNS; if you choose a domain ending in `.local`, devices may resolve names unpredictably. Prefer `.internal` or a subdomain you control.

---

These fixes should resolve most issues encountered during installation and initial configuration. Check logs (`/var/log/samba/` or `journalctl -u samba-ad-dc`) for additional errors.
