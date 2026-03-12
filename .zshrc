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

# Set NVM's home directory
export NVM_DIR="$HOME/.nvm"

# Source the nvm script provided by the Arch package
[ -s "/usr/share/nvm/init-nvm.sh" ] && . "/usr/share/nvm/init-nvm.sh"

# (Optional) This enables bash completion for nvm
[ -s "/usr/share/nvm/bash_completion" ] && . "/usr/share/nvm/bash_completion"

# Initialize Starship
eval "$(starship init zsh)"
