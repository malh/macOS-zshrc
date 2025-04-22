#!/usr/bin/env bash

# macOS-zshrc Installation Script

# --- Helper Functions ---
print_info() {
  echo -e "\033[34mINFO:\033[0m $1"
}

print_success() {
  echo -e "\033[32mSUCCESS:\033[0m $1"
}

print_warning() {
  echo -e "\033[33mWARNING:\033[0m $1"
}

print_error() {
  echo -e "\033[31mERROR:\033[0m $1" >&2
}

prompt_user() {
  read -p "$1 " choice
  echo "$choice"
}

# --- Script Setup ---
set -e # Exit immediately if a command exits with a non-zero status.

# Determine the directory where the script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ZSHRC="$SCRIPT_DIR/.zshrc"
REPO_PLUGINS="$SCRIPT_DIR/.zsh_plugins.txt" # Assuming plugins file is in the repo
TARGET_ZSHRC="$HOME/.zshrc"
TARGET_PLUGINS="$HOME/.zsh_plugins.txt"

# --- Homebrew Check ---
print_info "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
  print_info "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH for the current script execution
  eval "$(/opt/homebrew/bin/brew shellenv)" # Apple Silicon
  if [[ -f "/usr/local/bin/brew" ]]; then # Intel
      eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  print_success "Homebrew found."
fi

# --- Backup Existing Files ---
print_info "Backing up existing configuration files..."
if [ -f "$TARGET_ZSHRC" ] || [ -L "$TARGET_ZSHRC" ]; then
  backup_file="$TARGET_ZSHRC.backup-$(date +%Y%m%d%H%M%S)"
  print_info "Backing up $TARGET_ZSHRC to $backup_file"
  mv "$TARGET_ZSHRC" "$backup_file"
fi
if [ -f "$TARGET_PLUGINS" ] || [ -L "$TARGET_PLUGINS" ]; then
  backup_file="$TARGET_PLUGINS.backup-$(date +%Y%m%d%H%M%S)"
  print_info "Backing up $TARGET_PLUGINS to $backup_file"
  mv "$TARGET_PLUGINS" "$backup_file"
fi

# --- Symlink Configuration Files ---
print_info "Symlinking configuration files..."
if [ ! -f "$REPO_ZSHRC" ]; then
    print_error "Repository .zshrc file not found at $REPO_ZSHRC"
    exit 1
fi
ln -sv "$REPO_ZSHRC" "$TARGET_ZSHRC"

# Decide whether to link the plugins file or let user manage it
# Option 1: Link the repo's plugin file (easier updates, less user flexibility)
if [ -f "$REPO_PLUGINS" ]; then
    ln -sv "$REPO_PLUGINS" "$TARGET_PLUGINS"
else
    print_warning "Repository .zsh_plugins.txt not found at $REPO_PLUGINS. Skipping symlink."
    print_info "You will need to create $TARGET_PLUGINS manually."
fi
# Option 2: Don't link, let user create ~/.zsh_plugins.txt (comment above and uncomment below)
# print_info "Skipping .zsh_plugins.txt symlink. Please create and manage this file yourself."


# --- Install Dependencies ---
print_info "Installing dependencies via Homebrew..."
dependencies=(
  antidote # Plugin manager
  eza      # ls replacement
  bat      # cat replacement
  fzf      # Fuzzy finder
)
fonts=(
  font-hack-nerd-font # Font with icons for eza
)

# Prompt user to choose between autojump and zoxide
print_info "Would you like to use autojump or zoxide for directory jumping?"
print_info "1) autojump (recommended if you're new to this)"
print_info "2) zoxide (faster alternative)"
choice=$(prompt_user "Enter 1 or 2:")

if [[ "$choice" == "2" ]]; then
  print_info "Adding zoxide to installation list."
  dependencies+=(zoxide)
else
  print_info "Adding autojump to installation list (default)."
  dependencies+=(autojump)
fi

brew update # Update brew recipes first

# Install dependencies
for dep in "${dependencies[@]}"; do
  if brew list "$dep" &> /dev/null; then
    print_info "$dep is already installed. Skipping."
  else
    print_info "Installing $dep..."
    brew install "$dep"
  fi
done

# Tap fonts cask and install fonts
print_info "Installing Nerd Font..."

for font in "${fonts[@]}"; do
   if brew list --cask "$font" &> /dev/null; then
    print_info "$font is already installed. Skipping."
  else
    print_info "Installing $font..."
    brew install --cask "$font"
   fi
done


# --- Post-install Steps ---
print_info "Running fzf installation script..."
if [[ -f "$(brew --prefix fzf)/install" ]]; then
  "$(brew --prefix fzf)/install" --all --no-bash --no-fish
  print_success "fzf configured."
else
  print_warning "fzf installation script not found. Please run it manually if needed."
fi

# --- eza Theme Setup (Optional) ---
EZA_CONFIG_DIR="$HOME/.config/eza"
EZA_THEMES_DIR="$EZA_CONFIG_DIR/eza-themes"
EZA_THEME_LINK="$EZA_CONFIG_DIR/theme.yml"
DEFAULT_THEME_SOURCE="$EZA_THEMES_DIR/themes/default.yml"

print_info "Setting up eza themes (optional)..."
if [ ! -d "$EZA_CONFIG_DIR" ]; then
  mkdir -p "$EZA_CONFIG_DIR"
  print_info "Created eza config directory: $EZA_CONFIG_DIR"
fi

if [ ! -d "$EZA_THEMES_DIR" ]; then
  print_info "Cloning eza themes..."
  git clone https://github.com/eza-community/eza-themes.git "$EZA_THEMES_DIR"
else
  print_info "eza themes directory already exists. Skipping clone."
  # Optional: Add logic to pull updates if desired
  # ( cd "$EZA_THEMES_DIR" && git pull )
fi

if [ -f "$DEFAULT_THEME_SOURCE" ]; then
  if [ ! -L "$EZA_THEME_LINK" ]; then
      ln -sv "$DEFAULT_THEME_SOURCE" "$EZA_THEME_LINK"
      print_success "Linked default eza theme."
  else
      print_info "eza theme link already exists."
  fi
else
    print_warning "Default eza theme not found in cloned repo. Cannot create symlink."
fi


# --- Final Instructions ---
print_success "macOS-zshrc installation complete!"
print_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
print_info "Remember to configure your terminal emulator (e.g., iTerm2, Terminal.app) to use the 'Hack Nerd Font'." 