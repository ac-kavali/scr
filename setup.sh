#!/bin/bash

# Exit on error
set -e

TARGET_USER="kali"
TARGET_HOME="/home/$TARGET_USER"

echo "[+] Starting setup for user: $TARGET_USER"

# Install gdown (will ask for password if not root)
echo "[+] Installing gdown..."
apt update -y
apt install -y gdown

# Download file using gdown
echo "[+] Downloading setup archive..."
cd /tmp
gdown ak32a34vjfq3e3wr32

# Extract archive
echo "[+] Extracting archive..."
tar -xf setup.tar.xz

# Change shell to zsh
echo "[+] Changing default shell to zsh for $TARGET_USER..."
usermod -s /bin/zsh $TARGET_USER

# Move configuration files
echo "[+] Moving configuration files..."

mv -v /tmp/setup/.zshrc $TARGET_HOME/
mv -v /tmp/setup/.config $TARGET_HOME/
mv -v /tmp/setup/.cache $TARGET_HOME/
mv -v /tmp/setup/.local $TARGET_HOME/
mv -v /tmp/setup/.ssh $TARGET_HOME/
mv -v /tmp/setup/.mozilla $TARGET_HOME/
mv -v /tmp/setup/.zsh_history $TARGET_HOME/

# Fix ownership (VERY IMPORTANT)
echo "[+] Fixing ownership..."
chown -R $TARGET_USER:$TARGET_USER $TARGET_HOME

echo "[+] Setup completed successfully!"
