# SSH Key Installer

Simple script to install an SSH public key into `authorized_keys`.

## Usage

Run the script:

```bash
./setup-ssh-key.sh
```

Paste your public SSH key when prompted.

After installation, you can connect via SSH without a password.

## Features

- Creates `.ssh` directory if missing
- Sets correct permissions
- Appends public key safely
- Lightweight and portable