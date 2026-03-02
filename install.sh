#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

echo "Installing packages..."

# Use yay/paru if available, otherwise install yay
if command -v yay &>/dev/null; then
  PACMAN=yay
elif command -v paru &>/dev/null; then
  PACMAN=paru
else
  echo "Installing yay..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd -
  PACMAN=yay
fi

$PACMAN -S --needed
# Base development tools
wget \
  git \
  vim \
  btop \
  ffmpeg \
  python \
  nodejs \
  jq \
  php \
  mariadb \
  redis \
  libappindicator \
  libdbusmenu \
  libnotify \
  ddcutil \
  tailscale \
  make \
  gcc \
  binutils \
  desktop-file-utils

# Fonts
nerd-fonts-comic-shanns-mono \
  noto-fonts \
  noto-fonts-cjk

# Terminal & Shell
zellij \
  wl-clipboard \
  kitty \
  zsh \
  starship \
  fastfetch \
  bash-completion \
  zsh-completions

# Hyprland & Wayland
hyprland \
  hyprpaper \
  hypridle \
  hyprlock \
  hyprpolkitagent \
  hyprshot \
  tofi \
  swaynotificationcenter \
  tuigreet \
  greetd

# GUI Apps
thunderbird \
  mpv \
  swappy \
  imv \
  pavucontrol \
  networkmanagerapplet \
  yazi \
  nautilus \
  gvfs \
  gnome-disk-utility \
  libreoffice-fresh \
  ark \
  zip \
  unzip \
  unrar \
  p7zip \
  gzip \
  playerctl \
  yarn \
  appimage \
  anki \
  brave \
  firefox \
  discord

# 1Password
onepassword-cli \
  1password

# Themes & Icons
catppuccin-gtk-theme-mocha \
  catppuccin-kvantum \
  bibata-cursors \
  yaru \
  kvantum

# Graphics & Gaming
mangohud \
  gamescope \
  proton-ge-custom \
  steam \
  gamemode \
  libva \
  libva-vdpau-driver \
  libvdpau-va-gl

# Flatpak
flatpak

# Neovim dependencies
lua-language-server \
  stylua \
  ripgrep \
  fzf \
  fd \
  lazygit \
  cargo \
  tree-sitter \
  nixfmt \
  bash-language-server \
  vscode-langservers-extracted \
  marksman \
  taplo \
  inotify-tools \
  prettier \
  shfmt \
  tailwindcss-language-server \
  typescript-language-server \
  vue-language-server

# Misc
tldr \
  trezor-suite \
  jellyfin-mpv-shim \
  jellyfin-media-player \
  epiphany

# Services
blueman \
  bluez \
  bluez-utils

# Enable services
systemctl enable bluetooth
systemctl enable greetd
systemctl enable tailscale

# Copy config files
echo "Copying config files..."

mkdir -p "$HOME/.config"

# Hyprland
cp -r "$CONFIG_DIR/hypr" "$HOME/.config/"

# Neovim (LazyVim)
cp -r "$CONFIG_DIR/nvim" "$HOME/.config/"

# Zellij
cp -r "$CONFIG_DIR/zellij" "$HOME/.config/"

# Tofi
cp -r "$CONFIG_DIR/tofi" "$HOME/.config/"

# Waybar
cp -r "$CONFIG_DIR/waybar" "$HOME/.config/"

# OpenCode
cp -r "$CONFIG_DIR/opencode" "$HOME/.config/"

# WiVRn
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
mkdir -p "$HOME/dotfiles/config"
ln -sf "$CONFIG_DIR" "$HOME/dotfiles/config"

# Set default shell to zsh
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
