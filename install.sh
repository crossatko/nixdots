#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

echo "Enabling multilib repository for 32-bit gaming packages..."
# Uncomment [multilib] and the Include line directly below it
sudo sed -i '/^#\[multilib\]/s/^#//' /etc/pacman.conf
sudo sed -i '/^\[multilib\]/,/^#Include/s/^#Include/Include/' /etc/pacman.conf

echo "Syncing repositories and installing prerequisites..."
# We must sync (-Sy) because we just added the multilib repository,
# and we need base-devel and git first to build yay from the AUR
sudo pacman -Sy --needed --noconfirm base-devel git

echo "Setting up AUR helper..."
# Use yay/paru if available, otherwise install yay
if command -v yay &>/dev/null; then
  PACMAN=yay
elif command -v paru &>/dev/null; then
  PACMAN=paru
else
  echo "Installing yay..."
  # Clean up any leftover directories from failed runs
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  PACMAN=yay
fi

echo "Installing packages..."

# Define all packages in an array so we can cleanly use comments and newlines
PACKAGES=(
  # Base development tools
  wget git vim btop ffmpeg python nodejs jq php mariadb redis
  libappindicator libdbusmenu libnotify ddcutil tailscale
  make gcc binutils desktop-file-utils

  # Fonts
  nerd-fonts-comic-shanns-mono noto-fonts noto-fonts-cjk

  # Terminal & Shell
  zellij wl-clipboard kitty zsh starship fastfetch bash-completion zsh-completions

  # Hyprland & Wayland
  hyprland hyprpaper hypridle hyprlock hyprpolkitagent hyprshot tofi
  swaynotificationcenter tuigreet greetd

  # GUI Apps
  thunderbird mpv swappy imv pavucontrol networkmanagerapplet yazi nautilus
  gvfs gnome-disk-utility libreoffice-fresh ark zip unzip unrar p7zip gzip
  playerctl yarn appimage anki brave firefox discord

  # 1Password
  onepassword-cli 1password

  # Themes & Icons
  catppuccin-gtk-theme-mocha catppuccin-kvantum bibata-cursors yaru kvantum

  # Graphics & Gaming
  mangohud gamescope proton-ge-custom steam gamemode libva libva-vdpau-driver libvdpau-va-gl

  # Flatpak
  flatpak

  # Neovim dependencies
  lua-language-server stylua ripgrep fzf fd lazygit cargo tree-sitter nixfmt
  bash-language-server vscode-langservers-extracted marksman taplo
  inotify-tools prettier shfmt tailwindcss-language-server typescript-language-server
  vue-language-server

  # Misc
  tldr trezor-suite jellyfin-mpv-shim jellyfin-media-player epiphany

  # Services
  blueman bluez bluez-utils
)

# Install all packages
$PACMAN -S --needed --noconfirm "${PACKAGES[@]}"

# Enable services
echo "Enabling services..."
sudo systemctl enable bluetooth
sudo systemctl enable greetd
sudo systemctl enable tailscale

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

echo "Installation complete!"
echo "You may need to:"
echo "  1. Log out and log back in"
echo "  2. Run 'fc-cache -fv' to refresh fonts"
echo "  3. Configure flatpak: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
