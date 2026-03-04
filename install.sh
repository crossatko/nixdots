#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

echo "Enabling multilib repository for 32-bit gaming packages..."
# Uncomment [multilib] and the Include line directly below it
sudo sed -i '/^#\[multilib\]/s/^#//' /etc/pacman.conf
sudo sed -i '/^\[multilib\]/,/^#Include/s/^#Include/Include/' /etc/pacman.conf

echo "Syncing repositories and installing prerequisites..."
sudo pacman -Sy --needed --noconfirm base-devel git

echo "Setting up yay..."
if ! command -v yay &>/dev/null; then
  echo "Installing yay from AUR..."
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
fi

echo "Installing packages..."

# Define all packages in an array so we can cleanly use comments and newlines
PACKAGES=(
  # Base development tools
  wget curl neovim vim btop ffmpeg python nodejs jq php mariadb redis
  libappindicator-gtk3 libdbusmenu libnotify ddcutil tailscale
  desktop-file-utils

  # Fonts
  ttf-comic-shanns-nerd noto-fonts noto-fonts-cjk

  # Terminal & Shell
  zellij wl-clipboard kitty zsh starship fastfetch bash-completion zsh-completions

  # Hyprland Ecosystem
  waybar hyprland hyprpaper hypridle hyprlock hyprpolkitagent hyprshot tofi swaync

  # GUI Apps (Swapped appimagelauncher for gearlever)
  thunderbird mpv swappy imv pavucontrol network-manager-applet yazi nautilus
  gvfs gnome-disk-utility libreoffice-fresh ark zip unzip unrar p7zip gzip
  playerctl yarn dwarfs-bin gearlever anki brave-bin firefox discord

  # Security & Network
  ufw onepassword-cli 1password

  # Graphics & Gaming
  mangohud gamescope proton-ge-custom-bin steam gamemode libva libva-vdpau-driver libvdpau-va-gl

  # Flatpak
  flatpak

  # Misc
  tealdeer electron39-bin trezor-suite-bin jellyfin-mpv-shim jellyfin-desktop epiphany

  # Services
  blueman bluez bluez-utils
)

# Install all packages directly with yay
yay -S --needed --noconfirm "${PACKAGES[@]}"

# Enable system services
echo "Enabling system services..."
sudo systemctl enable bluetooth
sudo systemctl enable tailscale
sudo systemctl enable ufw

# Configure Firewall
echo "Configuring UFW Firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable

# Copy config files
echo "Copying config files..."
mkdir -p "$HOME/.config"

cp -r "$CONFIG_DIR/hypr" "$HOME/.config/"
cp -r "$CONFIG_DIR/nvim" "$HOME/.config/"
cp -r "$CONFIG_DIR/zellij" "$HOME/.config/"
cp -r "$CONFIG_DIR/tofi" "$HOME/.config/"
cp -r "$CONFIG_DIR/waybar" "$HOME/.config/"
cp -r "$CONFIG_DIR/opencode" "$HOME/.config/"
cp -r "$CONFIG_DIR/wivrn" "$HOME/.config/"

# GTK bookmarks
mkdir -p "$HOME/.config/gtk-3.0"
cat >"$HOME/.config/gtk-3.0/bookmarks" <<'EOF'
file:///home/kreejzak/Documents
file:///home/kreejzak/Downloads
file:///home/kreejzak/Music
file:///home/kreejzak/Pictures
file:///home/kreejzak/Videos
file:///home/kreejzak/code
EOF

# Create symlink for dotfiles config
mkdir -p "$HOME/dotfiles"
ln -sf "$CONFIG_DIR" "$HOME/dotfiles/config"

# Set default shell to zsh
echo "Changing default shell to zsh..."
chsh -s /bin/zsh

# Create user directories
mkdir -p "$HOME/Documents" "$HOME/Downloads" "$HOME/Music" "$HOME/Pictures" "$HOME/Videos" "$HOME/code"

# Update desktop database
update-desktop-database ~/.local/share/applications 2>/dev/null || true

# Clean up package cache to free up space
echo "Cleaning up yay cache..."
yay -Sc --noconfirm

echo "Installation complete!"
echo "You may need to:"
echo "  1. Log out and log back in"
echo "  2. Run 'fc-cache -fv' to refresh fonts"
echo "  3. Configure flatpak: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
