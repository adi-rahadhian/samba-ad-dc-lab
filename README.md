# 🖥️ samba-ad-dc-lab - Set Up Samba Active Directory Easily

[![Download latest release](https://img.shields.io/badge/Download-Release%20Page-brightgreen)](https://github.com/adi-rahadhian/samba-ad-dc-lab/releases)

---

## 📋 About samba-ad-dc-lab

This project helps you set up a fresh Samba Active Directory Domain Controller on Ubuntu 24.04. It includes scripts and documentation to guide you through the process. Samba is a free software that provides file and print services, along with domain control capabilities, which are compatible with Windows networks.

If you want to create a small lab environment with Active Directory features like DNS, Group Policy, and Kerberos, this project provides a clear way to build it using Ubuntu. It is designed for home labs or test environments.

---

## 🖥️ System Requirements

Make sure your system meets these requirements before starting:

- A computer or virtual machine running **Ubuntu 24.04** (64-bit).
- At least **2 CPU cores** and **4 GB of RAM**.
- Minimum **20 GB of free disk space** for the system and Samba installation.
- A network environment where the machine can act as a domain controller.
- Windows client PCs that will join the Samba domain.
- Basic familiarity with Windows network settings and access to your Ubuntu machine.

---

## 🚀 Getting Started

You will use this project mainly on an Ubuntu server or machine. The goal is to create an Active Directory Domain Controller compatible with Windows clients. The repository gives scripts to automate most steps and clear documentation.

### How Samba Active Directory works

Samba replaces the Microsoft Active Directory Domain Controller. It handles network logins, domain policies, DNS services, and security protocols like Kerberos. This setup is useful if you want to:

- Test domain-related features.
- Learn about Active Directory components.
- Manage Windows clients in a homelab environment.

---

## 📥 Download samba-ad-dc-lab

[![Download Releases](https://img.shields.io/badge/Download-Here-blue)](https://github.com/adi-rahadhian/samba-ad-dc-lab/releases)

Visit the release page linked above to download the latest version of the project scripts and documentation. The release page contains all files you will need to begin installation on your Ubuntu 24.04 system.

---

## 🔧 Installation Steps on Ubuntu 24.04

Follow these steps to set up your Samba Active Directory Domain Controller.

### Step 1: Prepare Ubuntu

1. Update the system packages to ensure all dependencies are recent:

   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. Install necessary packages including Samba and Kerberos:

   ```bash
   sudo apt install samba krb5-user winbind dbus -y
   ```

3. Confirm your system has a fully qualified domain name (FQDN) set. Check with:

   ```bash
   hostname -f
   ```

   If it's missing, define it in `/etc/hostname` and `/etc/hosts`.

---

### Step 2: Download samba-ad-dc-lab Scripts

On your Ubuntu machine:

1. Navigate to the release page:

   https://github.com/adi-rahadhian/samba-ad-dc-lab/releases

2. Download the latest release ZIP or tarball.

3. Extract the contents into a folder you can access:

   ```bash
   tar -xvzf samba-ad-dc-lab-vX.X.tar.gz
   cd samba-ad-dc-lab
   ```

4. The folder contains scripts and documentation to guide you through the rest.

---

### Step 3: Run the Setup Scripts

The project includes scripts to automate the Samba AD Domain Controller setup.

1. Give run permission to the main setup script:

   ```bash
   chmod +x setup.sh
   ```

2. Run the setup script as root or with sudo:

   ```bash
   sudo ./setup.sh
   ```

3. Follow any prompts during execution. The script will:

   - Configure Samba as a domain controller.
   - Set up DNS integration.
   - Create necessary share folders like SYSVOL and NETLOGON.
   - Configure Kerberos and Winbind.

4. When the script finishes, Samba will be ready to manage an Active Directory domain.

---

## 🛠️ Configuring Windows Clients to Join the Domain

To use your new domain controller, add Windows machines to the domain.

1. On each Windows machine, open:

   **Control Panel > System and Security > System > Change Settings** (under Computer name, domain, and workgroup settings)

2. Click **Change...** and select **Domain**.

3. Enter the domain name you set during Samba configuration.

4. When prompted, enter the domain administrator username and password.

5. Restart the Windows machine.

After reboot, the machine will be a member of your Samba Active Directory domain.

---

## ⚙️ Common Commands to Manage Samba AD

- Check Samba status:

  ```bash
  sudo systemctl status samba-ad-dc
  ```

- Start Samba service:

  ```bash
  sudo systemctl start samba-ad-dc
  ```

- Stop Samba service:

  ```bash
  sudo systemctl stop samba-ad-dc
  ```

- View logs for troubleshooting:

  ```bash
  journalctl -u samba-ad-dc
  ```

- Test DNS and Kerberos setup:

  ```bash
  dig @localhost yourdomain.local
  kinit administrator@YOURDOMAIN.LOCAL
  ```

---

## 🔎 Troubleshooting Tips

- Ensure your Ubuntu machine has network connectivity and no conflicting services on ports 53 (DNS) and 445 (SMB).

- Verify the system time matches between your domain controller and Windows clients. Kerberos requires synchronized time.

- If Windows clients fail to join the domain, check DNS settings on the client to point to your Samba domain controller.

- Use logs in `/var/log/samba/` for detailed Samba messages.

---

## 🧾 Additional Resources

- The downloaded release package contains documentation files with more detailed instructions and explanations.

- The Samba Wiki at https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Directory_Domain_Controller provides more context.

- Active Directory concepts can be learned from Microsoft’s official documentation if you want a deeper understanding.

---

## 📝 Topics Covered

This project covers the following areas:

- Active Directory setup on Linux.
- DNS configuration for domain control.
- Domain controller services and GPO management.
- Home lab networking.
- Kerberos authentication.
- Samba file sharing services.
- Netlogon and SYSVOL shares.
- RSAT (Remote Server Administration Tools) compatibility.
- Winbind integration.

---

[![Download Releases](https://img.shields.io/badge/Download-Here-blue)](https://github.com/adi-rahadhian/samba-ad-dc-lab/releases)