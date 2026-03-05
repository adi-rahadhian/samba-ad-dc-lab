# Prerequisites and Installation

This document explains how to prepare a fresh **Ubuntu 24.04** server for the Samba Active Directory Domain Controller (AD DC) lab.  These steps ensure the host has a stable identity and all required packages before the domain is provisioned.

## 1. System configuration

- **Static IP and hostname:**
  - Choose a fixed IP on your network (for example `10.0.0.252/24`).
  - Pick a fully‑qualified domain name (FQDN) for the domain controller (e.g. `dc1.test.local`).  Avoid `.local` in mixed networks — for production use a subdomain like `corp.internal` or one you control.
  - Set the hostname with `hostnamectl` and add an entry in `/etc/hosts` mapping the IP to the FQDN and short hostname.  For example:

    ```bash
    sudo hostnamectl set-hostname dc1.test.local
    sudo nano /etc/hosts
    # Add or update the line below:
    10.0.0.252  dc1.test.local dc1
    ```

- **Time synchronisation:** Kerberos is extremely sensitive to clock drift.  Ensure the host uses **chrony** or **systemd‑timesyncd**.  The example scripts install `chrony` as part of the package set.

## 2. Install required packages

Update package lists and install Samba and supporting tools.  The `samba‑ad‑dc` package bundles the correct `winbindd` binary for an AD DC and prevents conflicts with the file‑server mode.

```bash
sudo apt update
sudo apt install -y samba samba-ad-dc winbind krb5-user smbclient dnsutils chrony
```

### What each package does

- **samba / samba‑ad‑dc** – provides the smbd/nmbd/winbindd daemons and the `samba-tool` utility used to provision the domain.
- **winbind** – resolves Windows user and group information.  On an AD DC this comes from the `samba‑ad‑dc` meta‑package.
- **krb5-user** – prompts for Kerberos defaults during install; its `/etc/krb5.conf` will later be replaced by Samba’s own.
- **dnsutils** – provides the `host` and `dig` commands for DNS testing.
- **chrony** – lightweight time server ensuring accurate clocks.
- **smbclient** – useful for testing SMB connectivity.

## 3. Stop and disable conflicting services

A domain controller runs a single `samba-ad-dc` process instead of the traditional `smbd`, `nmbd` and `winbindd`.  Stop and disable these standalone services before provisioning:

```bash
sudo systemctl disable --now smbd nmbd winbind
sudo pkill smbd nmbd winbindd || true
sudo rm -f /run/samba/*.pid
```

## 4. Prepare your environment file

The provided scripts read configuration variables from `scripts/00-env`.  Copy the example to create your lab‑specific file:

```bash
cd samba-ad-dc-lab/scripts
cp 00-env.example 00-env
nano 00-env
```

Edit the following variables to match your environment:

- `DC_IP` – the static IP address (e.g. `10.0.0.252`)
- `DC_FQDN` – the fully‑qualified domain name (e.g. `dc1.test.local`)
- `DC_HOST` – the short hostname (`dc1`)
- `REALM` – the Kerberos realm in uppercase (`TEST.LOCAL`)
- `DOMAIN` – the NetBIOS name in uppercase (`TEST`)
- `DNS_FORWARDER` – an upstream resolver (e.g. `9.9.9.9` or `1.1.1.1`)

Optional variables include organisational units (OUs) and a user to create after provisioning.  Leaving `NEW_USER_PASSWORD` blank will prompt interactively when the account is created.

Once configured, run the installation script (as root):

```bash
sudo bash scripts/10-prereqs.sh
sudo bash scripts/20-install.sh
```

These scripts apply the hostname, update `/etc/hosts`, install packages and disable conflicting services.  You are now ready to provision the domain.
