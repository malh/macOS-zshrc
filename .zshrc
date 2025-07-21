# =====================================================
# macOS-zshrc: Enhanced zsh config (zshrc) for macOS users who like their prompts fast 
# and their eza pretty.
# 
# Original repository: https://github.com/malh/macOS-zshrc
# =====================================================

# === Environment Variables ===
export LANG=en_US.UTF-8
export EDITOR="nano"  # Change to vim/emacs if preferred
export HOMEBREW_AUTO_UPDATE_SECS="86400"

# eza theme configuration
export EZA_THEME_PATH="$HOME/.config/eza/theme.yml"

# === History Configuration ===
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # Don't record duplicate commands
setopt HIST_IGNORE_SPACE      # Don't record commands that start with a space
setopt HIST_VERIFY            # Show command with history expansion before running it
setopt SHARE_HISTORY          # Share history between all sessions

# === Directory Navigation ===
setopt AUTO_CD                # Type directory name to cd into it
setopt AUTO_PUSHD             # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS      # Don't push duplicates onto the directory stack
setopt PUSHD_SILENT           # Don't print directory stack after pushd/popd

# === Completion System ===
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select                    # Menu-style completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colored completion

# === Aliases ===
# File navigation with eza (modern ls replacement with icons by default)
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias la="eza -a --icons"
alias lt="eza --tree --icons"
alias l.="eza -d .* --icons"
alias l="eza -F --icons"
alias lh="eza -lah --icons"  # Human-readable sizes
alias lm="eza -la --sort=modified --icons"  # Sort by modified time
alias lS="eza -la --sort=size --icons"  # Sort by file size

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias glog="git log --oneline --decorate --graph"

# System
alias zshrc="$EDITOR ~/.zshrc"
alias vzshrc="$EDITOR ~/.zshrc"
alias szshrc="source ~/.zshrc"

# Python
alias py="python"
alias ipy="ipython"
alias jn="jupyter notebook"
alias jl="jupyter lab"

# Mac-specific shortcuts
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias lock="osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down,control down}'"   

# Application shortcuts
alias safari="open -a Safari"
alias vscode="open -a 'Visual Studio Code'"
alias chrome="open -a 'Google Chrome'"

# Clipboard integration
alias copy="pbcopy"
alias paste="pbpaste"
alias cpwd="pwd | tr -d '\n' | pbcopy"  # Copy current directory path

# === Path Configuration ===
# Homebrew - completely modular path handling for maximum compatibility
# Support for standard locations, custom installations, and user preferences

# First, try to find the brew command
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  # Apple Silicon Mac (M1/M2/M3) standard location
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  # Intel Mac standard location
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x "$HOME/.homebrew/bin/brew" ]]; then
  # User directory installation
  eval "$($HOME/.homebrew/bin/brew shellenv)"
elif [[ -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
  # User-specified custom location via HOMEBREW_PREFIX
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
else
  # Fallback - try to find brew anywhere in PATH
  if command -v brew >/dev/null; then
    eval "$(brew shellenv)"
  else
    # Last resort - add common Homebrew paths if brew not found
    for dir in "/opt/homebrew/bin" "/usr/local/bin" "$HOME/.homebrew/bin" "$HOME/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/bin"; do
      [[ -d "$dir" ]] && export PATH="$dir:$PATH"
    done
  fi
fi

# Add additional Homebrew environment variables (if Homebrew is installed)
if command -v brew >/dev/null; then
  export HOMEBREW_NO_ANALYTICS=1  # Disable analytics
  export HOMEBREW_CASK_OPTS="--no-quarantine"  # Don't quarantine apps
  export HOMEBREW_NO_ENV_HINTS=1  # Reduce hint messages
fi

# NVM Configuration - flexible approach for any installation method
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"  # Allow custom NVM_DIR or default to ~/.nvm

# Load NVM - try all possible locations
if command -v brew >/dev/null && [[ -d "$(brew --prefix nvm 2>/dev/null)" ]]; then
  # If Homebrew is available, use brew --prefix to find nvm precisely
  source "$(brew --prefix nvm)/nvm.sh"
  # Also load bash completion if available
  [[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ]] && source "$(brew --prefix nvm)/etc/bash_completion.d/nvm"
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # Standard NVM directory installation
  source "$NVM_DIR/nvm.sh"
  # Also load bash completion if available
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
elif [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  # Apple Silicon Homebrew path
  source "/opt/homebrew/opt/nvm/nvm.sh"
  [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
elif [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
  # Intel Mac Homebrew path
  source "/usr/local/opt/nvm/nvm.sh"
  [[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
fi

# Anaconda/Miniconda Configuration - modular version
# Function to add conda to path and initialize if it exists
_init_conda() {
  local conda_path="$1"
  if [[ -d "$conda_path/bin" ]]; then
    # Add to PATH if not already there
    [[ ":$PATH:" != *":$conda_path/bin:"* ]] && export PATH="$conda_path/bin:$PATH"
    
    # Initialize conda if the conda command exists
    if [[ -x "$conda_path/bin/conda" ]]; then
      # Set up conda initialization
      # Commented out by default to speed up shell startup - uncomment if needed
      # eval "$("$conda_path/bin/conda" "shell.zsh" "hook")"
      return 0
    fi
  fi
  return 1
}

# Try to find Conda installation in order of preference
if [[ -n "$CONDA_PREFIX" ]]; then
  # User has set their own Conda prefix
  _init_conda "$CONDA_PREFIX"
elif _init_conda "$HOME/miniconda3" || _init_conda "$HOME/anaconda3" ||
     _init_conda "/opt/homebrew/anaconda3" || _init_conda "/usr/local/anaconda3" ||
     _init_conda "/opt/miniconda3" || _init_conda "/opt/anaconda3"; then
  # One of the common locations worked
  true
fi
unset -f _init_conda  # Clean up the function

# === Plugin Management ===
# Load Antidote. This assumes you've installed it (e.g., brew install antidote)
# It sources ~/.zsh_plugins.txt to load your plugins.
if [[ -f "$(brew --prefix antidote)/share/antidote/antidote.zsh" ]]; then
  source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
  antidote load
else
  echo "Antidote not found. Please install it (e.g., brew install antidote)."
fi

# bat - better cat with syntax highlighting
# Note: Bat is not a zsh plugin, so its alias/config remains here
if command -v bat >/dev/null; then
  alias cat="bat --style=plain"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# === Prompt Configuration ===
# Load colors and vcs_info for git branch display
autoload -Uz colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }

# Configure vcs_info
zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f'
zstyle ':vcs_info:*' enable git

# Create single-line prompt with username, hostname, current directory, and git branch
setopt PROMPT_SUBST
PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{yellow}%~%f ${vcs_info_msg_0_} %F{blue}❯%f '

# Right prompt with timestamp
RPROMPT='%F{240}[%*]%f'

# === Functions ===
# Make directory and cd into it
mcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract common file formats
extract() {
    local file="$1"
    if [ -f "$file" ]; then
        case "$file" in
            *.tar.bz2)   tar xjf "$file"     ;;
            *.tar.gz)    tar xzf "$file"     ;;
            *.bz2)       bunzip2 "$file"     ;;
            *.rar)       unrar e "$file"     ;;
            *.gz)        gunzip "$file"      ;;
            *.tar)       tar xf "$file"      ;;
            *.tbz2)      tar xjf "$file"     ;;
            *.tgz)       tar xzf "$file"     ;;
            *.zip)       unzip "$file"       ;;
            *.Z)         uncompress "$file"  ;;
            *.7z)        7z x "$file"        ;;
            *)           echo "'$file' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$file' is not a valid file"
    fi
}

# Quick find
qfind() {
    find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# Display terminal colors
colors_demo() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolor ${i}\n"
    done
}

# Get IP address
myip() {
    echo "Public IP: $(curl -s ifconfig.me)"
    echo "Local IP: $(ipconfig getifaddr en0)"
}

# Get weather
weather() {
    curl -s "wttr.in/${1:-}"
}

# Create a backup of a file
backup() {
    cp "$1" "$1.bak"
    echo "Created backup of $1"
}

# === User Customizations ===
# Add your custom configurations below this line
# so they won't be overwritten when updating this file

# Load directory jumper (autojump or zoxide)
# The install script configures one of these options

# Option 1: Load autojump if installed via Homebrew
if command -v brew &>/dev/null && command -v autojump &>/dev/null; then
  AUTOJUMP_SCRIPT="$(brew --prefix autojump 2>/dev/null)/etc/profile.d/autojump.sh"
  if [[ -z "$AUTOJUMP_SCRIPT" ]] || [[ ! -f "$AUTOJUMP_SCRIPT" ]]; then
    # Fallback to common direct paths if brew --prefix fails or doesn't exist
    if [[ -f "/opt/homebrew/etc/profile.d/autojump.sh" ]]; then
      AUTOJUMP_SCRIPT="/opt/homebrew/etc/profile.d/autojump.sh"
    elif [[ -f "/usr/local/etc/profile.d/autojump.sh" ]]; then
      AUTOJUMP_SCRIPT="/usr/local/etc/profile.d/autojump.sh"
    fi
  fi
  
  # Source the script if found
  if [[ -f "$AUTOJUMP_SCRIPT" ]]; then
    . "$AUTOJUMP_SCRIPT"
  fi
  unset AUTOJUMP_SCRIPT # Clean up variable
fi

# Option 2: Initialize zoxide if installed
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
