#!/bin/bash

echo "======================================"
echo " SSH Public Key Installer"
echo "======================================"

read -p "Paste your public SSH key: " PUBKEY

mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "$PUBKEY" >> ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys

echo ""
echo "SSH key installed successfully."
echo "You can now connect without a password."