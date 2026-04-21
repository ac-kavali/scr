#!/bin/bash

# Exit on error
set -e

TARGET_USER="kali"
TARGET_HOME="/home/$TARGET_USER"
WORK_DIR="$TARGET_HOME/back"

echo "[+] Starting setup for user: $TARGET_USER"
echo "[+] Updating the system"
apt update -y 

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
gdown [gdownlink] -O setup.tar.xz.gpg

# Decrypting the packet using gpg (GNU Privacy Guard) 
gpg -d setup.tar.xz.gpg > setup.tar.xz

# Extract archive
echo "[+] Extracting archive..."
tar -xf setup.tar.xz

# Change shell to zsh
usermod -s /bin/zsh $TARGET_USER
echo "[OK]Default shell changed successfully to zsh!"
# Move configuration files
echo "[+] Moving configuration files..."
apt install -y rsync

mv -v "$WORK_DIR/setup/.zshrc" "$TARGET_HOME/"
echo "[OK] Zshrc configured successfly!"

mkdir -p "$TARGET_HOME/.config"
rsync -a --delete "$WORK_DIR/setup/.config/" "$TARGET_HOME/.config/"
echo "[OK] Config file Sync Successfully!"

mkdir -p "$TARGET_HOME/.cache"
rsync -a --delete "$WORK_DIR/setup/.cache/" "$TARGET_HOME/.cache/"
echo "[OK] Cache file Sync Successfully!"

mkdir -p "$TARGET_HOME/.mozilla"
cp -a "$WORK_DIR/setup/.mozilla/." "$TARGET_HOME/.mozilla/"
echo "[OK] Firefox Sync Sucessfully!"

rm -f "$TARGET_HOME/.zsh_history"
mv -v "$WORK_DIR/setup/.zsh_history" "$TARGET_HOME/.zsh_history"
echo "[OK] zsh_history Sync Successfuly!"

mkdir -p "$TARGET_HOME/.local/share"
cp -a "$WORK_DIR/setup/fonts" "$TARGET_HOME/.local/share/"
echo "[OK] Jetbrains Nerd Font Added sucessfully"

echo "Installing nautilus"
apt install -y nautilus 

# Fix ownership (VERY IMPORTANT)
echo "[+] Fixing ownership..."
chown -R $TARGET_USER:$TARGET_USER $TARGET_HOME


echo "[+] Installing cmatrix"
apt install cmatrix

echo "[+] Installing lsd"
apt install -y lsd

echo "[+] Moving your wallpaper to downloads"
cp -a "$WORK_DIR/setup/rack.jpg" "$TARGET_HOME/Downloads"

echo "[+] Cleaning"
rm -rf "$WORK_DIR"

echo "[+] Setup completed successfully!"


