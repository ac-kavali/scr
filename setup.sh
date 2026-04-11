#!/bin/bash

# Exit on error
set -e

TARGET_USER="kali"
TARGET_HOME="/home/$TARGET_USER"
WORK_DIR="$TARGET_HOME/back"

echo "[+] Starting setup for user: $TARGET_USER"

# Create working directory
echo "[+] Creating working directory at $WORK_DIR..."
mkdir -p "$WORK_DIR"

# Install gdown (will ask for password if not root)
echo "[+] Installing gdown..."
apt update -y
apt install -y gdown

# Download file using gdown
echo "[+] Downloading setup archive..."
cd "$WORK_DIR"
gdown 1M8bGOM48YgPngRiUIPN3zgdwxX_cbeKv -O setup.tar.xz

# Extract archive
echo "[+] Extracting archive..."
tar -xf setup.tar.xz

# Change shell to zsh
echo "[+] Changing default shell to zsh for $TARGET_USER..."
usermod -s /bin/zsh $TARGET_USER

# Move configuration files
echo "[+] Moving configuration files..."

mv -v "$WORK_DIR/setup/.zshrc" "$TARGET_HOME/"
mv -v "$WORK_DIR/setup/.config/*" "$TARGET_HOME/.config"
mv -v "$WORK_DIR/setup/.cache" "$TARGET_HOME/"
mv -v "$WORK_DIR/setup/.local/*" "$TARGET_HOME/*"
mv -v "$WORK_DIR/setup/.mozilla" "$TARGET_HOME/"
mv -v "$WORK_DIR/setup/.zsh_history" "$TARGET_HOME/"

# Fix ownership (VERY IMPORTANT)
echo "[+] Fixing ownership..."
chown -R $TARGET_USER:$TARGET_USER $TARGET_HOME

echo "[+] Setup completed successfully!"
