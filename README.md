# Samba AD DC Lab (Ubuntu 24.04)

This lab provisions a **Samba Active Directory Domain Controller** on Ubuntu 24.04 using Samba internal DNS.

Example lab values used here:
- Hostname: `dc1.test.local`
- IP: `10.0.0.252/24`
- Realm: `TEST.LOCAL`
- NetBIOS domain: `TEST`

> Note: Using `.local` can be problematic in mixed networks (mDNS). For real deployments prefer `corp.internal` or a subdomain you control.

## Quick start

# On a fresh Ubuntu 24.04 server (clean VM/box):
sudo apt update && sudo apt install -y git

git clone https://github.com/yossefseit/samba-ad-dc-lab.git
cd samba-ad-dc-lab

# Create your local config (NOT committed)
cp scripts/00-env.example scripts/00-env
nano scripts/00-env

# (Optional) make scripts executable
chmod +x scripts/*.sh

# Run in order
sudo bash scripts/10-prereqs.sh
sudo bash scripts/20-install.sh
sudo bash scripts/30-provision.sh
sudo bash scripts/40-dns-forwarder.sh
sudo bash scripts/50-verify.sh
sudo bash scripts/60-create-objects.sh

# Check service
sudo systemctl status samba-ad-dc --no-pager

## Documentation

Detailed guides for each stage of this lab are available in the `docs/` directory:

- [`01-install.md`](docs/01-install.md) – prerequisites and static IP/hostname setup.
- [`02-provision.md`](docs/02-provision.md) – domain provisioning.
- [`03-dns-kerberos.md`](docs/03-dns-kerberos.md) – DNS and Kerberos configuration.
- [`04-verify.md`](docs/04-verify.md) – verification checklist.
- [`troubleshooting.md`](docs/troubleshooting.md) – common issues and fixes.

Refer to these documents if you need more detail on a particular step or are troubleshooting problems.
