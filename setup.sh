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
gdown 1CoPPalTMU8eVNuAFXQhiq1JSheWUm1zA -O setup.tar.xz

# Extract archive
echo "[+] Extracting archive..."
tar -xf setup.tar.xz

# Change shell to zsh
echo "[+] Changing default shell to zsh for $TARGET_USER..."
usermod -s /bin/zsh $TARGET_USER

# Move configuration files
echo "[+] Moving configuration files..."
apt install -y rsync
mv -v "$WORK_DIR/setup/.zshrc" "$TARGET_HOME/"
mkdir /home/kali/.config 2>/dev/null
rsync -av /home/kali/back/setup/.config/ /home/kali/.config/
mkdir /home/kali/.cache 2>/dev/null
rsync -av /home/kali/back/setup/.cache/ /home/kali/.cache/
mkdir /home/kali/.mozilla 2>/dev/null
mv -v "$WORK_DIR/setup/.mozilla/*" "$TARGET_HOME/.mozilla/"
mv -v "$WORK_DIR/setup/.zsh_history" "$TARGET_HOME/"
mv /home/kali/back/setup/fonts /home/kali/.local/share

# Fix ownership (VERY IMPORTANT)
echo "[+] Fixing ownership..."
chown -R $TARGET_USER:$TARGET_USER $TARGET_HOME

echo "[+] Setup completed successfully!"
