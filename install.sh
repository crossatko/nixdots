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
  wget curl neovim vim btop ffmpeg python nodejs jq php mariadb redis yarn
  libappindicator-gtk3 libdbusmenu libnotify ddcutil tailscale
  desktop-file-utils

  # Fonts
  ttf-comic-shanns-nerd noto-fonts noto-fonts-cjk

  # Terminal & Shell
  zellij wl-clipboard kitty zsh starship fastfetch bash-completion zsh-completions

  # Hyprland Ecosystem
  waybar hyprland hyprpaper hypridle hyprlock hyprpolkitagent hyprshot tofi swaync

  # GUI Apps (Swapped appimagelauncher for gearlever)
  thunderbird mpv pavucontrol network-manager-applet yazi nautilus
  gnome-disk-utility libreoffice-fresh ark zip unzip unrar p7zip gzip
  playerctl anki

  # Security & Network
  ufw onepassword-cli 1password brave-bin firefox epiphany

  # Graphics & Gaming
  mangohud gamescope proton-ge-custom-bin steam gamemode libva libva-vdpau-driver libvdpau-va-gl

  # Containers & Virtualization
  docker docker-compose

  # Flatpak
  flatpak

  # Misc
  tldr

  # Services
  blueman bluez bluez-utils
)

# Install all packages directly with yay
yay -S --needed --noconfirm "${PACKAGES[@]}"

# Enable system services
echo "Enabling system services..."
sudo systemctl enable bluetooth
sudo systemctl enable --now tailscaled
sudo systemctl enable --now docker
sudo systemctl enable ufw

# Configure Firewall
echo "Configuring UFW Firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable

# Setup Docker permissions
echo "Configuring Docker permissions..."
sudo usermod -aG docker "$USER"

# Setup Flathub and install Flatpak apps
echo "Configuring Flathub and installing Discord & Spotify..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y flathub com.discordapp.Discord com.spotify.Client

# Symlink config files with backup logic
echo "Symlinking config files..."
mkdir -p "$HOME/.config"

CONFIG_APPS=("hypr" "nvim" "zellij" "tofi" "waybar" "opencode" "wivrn")

for app in "${CONFIG_APPS[@]}"; do
  TARGET="$HOME/.config/$app"
  SOURCE="$CONFIG_DIR/$app"

  # Check if the target already exists (as a file, directory, or even a broken symlink)
  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    echo "  Backing up existing $app to ${app}_backup..."
    # Remove older backup if it exists so mv doesn't fail or nest folders
    rm -rf "${TARGET}_backup"
    mv "$TARGET" "${TARGET}_backup"
  fi

  echo "  Symlinking $app..."
  ln -s "$SOURCE" "$TARGET"
done

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
fc-cache -fv

echo "Installation complete!"
echo "You may need to log out and log back in (required to apply Docker permissions)"
