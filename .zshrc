# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
plugins=(git sudo)
source $ZSH/oh-my-zsh.sh

# Arch Linux specific plugin paths for syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable completions
autoload -Uz compinit
compinit

# Aliases
alias udd="update-desktop-database ~/.local/share/applications"

# Nix-specific Alias (Only works if Nix package manager is installed on this Arch system)
alias nix-cleanup="sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5 && sudo nix-collect-garbage -d"

alias :q="exit"
alias vim="nvim"
alias up="make up"
alias upd="make up.d"
alias down="make down"
alias killdocker='docker kill $(docker ps -q)'
alias kd='docker kill $(docker ps -q)'

create_brave_webapp() {
  local app_name="$1"
  local app_url="$2"
  # Default to the brave icon if a specific one isn't passed
  local app_icon="${3:-brave}"

  # Format the filename to be lowercase and replace spaces with underscores
  local filename=$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
  local filepath="$HOME/.local/share/applications/webapp_${filename}.desktop"

  echo "  Adding $app_name ($app_url)..."
  mkdir -p "$HOME/.local/share/applications"

  cat >"$filepath" <<EOF
[Desktop Entry]
Version=1.0
Name=$app_name
Exec=brave --app="$app_url"
Terminal=false
Type=Application
Categories=Network;WebBrowser;
Icon=$app_icon
StartupNotify=true
EOF
}

# Convert all images in current directory to WebP
webp-all() {
  # Enable extended globbing (for #i) and nullglob (to avoid "no matches" errors)
  # 'localoptions' ensures these settings don't affect your whole shell session
  setopt localoptions extendedglob nullglob

  if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick is not installed."
    return 1
  fi

  # Find files. Now this will silently skip if a format is missing.
  local files=(*.(#i)(jpg|jpeg|png|tiff))

  if (( ${#files} == 0 )); then
    echo "No matching images found in the current directory."
    return 0
  fi

  for file in "${files[@]}"; do
    local output="${file%.*}.webp"
    echo "Converting: $file -> $output"
    magick "$file" -quality 75 "$output"
  done

  echo "Conversion complete!"
}

# Set NVM's home directory
export NVM_DIR="$HOME/.nvm"

# Source the nvm script provided by the Arch package
[ -s "/usr/share/nvm/init-nvm.sh" ] && . "/usr/share/nvm/init-nvm.sh"

# (Optional) This enables bash completion for nvm
[ -s "/usr/share/nvm/bash_completion" ] && . "/usr/share/nvm/bash_completion"

# Initialize Starship
eval "$(starship init zsh)"

# bun completions
[ -s "/home/kreejzak/.bun/_bun" ] && source "/home/kreejzak/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/kreejzak/.lmstudio/bin"
# End of LM Studio CLI section


if [ -e /home/kreejzak/.nix-profile/etc/profile.d/nix.sh ]; then . /home/kreejzak/.nix-profile/etc/profile.d/nix.sh; fi
export PATH="$HOME/.local/bin:$PATH"
