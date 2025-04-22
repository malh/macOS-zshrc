# macOS-zshrc

Enhanced zsh config (zshrc) for macOS users who like their prompts fast and their eza pretty.

A simple but powerful zsh setup made just for Mac. Makes your terminal look great and work better with colourful text, helpful shortcuts and smart features that remember where you've been. Perfect for coders or anyone who uses Terminal a lot but doesn't want to faff about with complicated setups.

## Table of Contents

- [Quick Look](#quick-look)
- [Cool Features](#cool-features)
- [Setting It Up](#setting-it-up)
- [How It's Organised](#how-its-organised)
- [What Each Bit Does](#what-each-bit-does)
  - [Basic Settings](#basic-settings)
  - [Command History](#command-history)
  - [Folder Navigation](#folder-navigation)
  - [Tab Completion](#tab-completion)
  - [Handy Shortcuts](#handy-shortcuts)
  - [System Paths](#system-paths)
  - [Extra Tools](#extra-tools)
  - [Command Prompt](#command-prompt)
  - [Useful Functions](#useful-functions)
- [Making File Lists Pretty](#making-file-lists-pretty)
- [Extra Tools Worth Adding](#extra-tools-worth-adding)
- [Making It Your Own](#making-it-your-own)
- [Fixing Common Problems](#fixing-common-problems)
- [Contributing](#contributing)
- [Licence](#licence)

## Quick Look

This zsh setup is specially made for Mac users who want their terminal to be both nicer to look at and easier to use. It takes the standard Mac terminal and gives it superpowers without getting too complicated.

You'll get:
- A colourful command prompt that shows git info
- Smart command history that remembers what you've done
- Better ways to move between folders
- Helpful tab completion that's more forgiving of typos
- Shortcuts for stuff you do all the time
- Pretty file listings with colours and icons
- Useful little functions that save you time

## Cool Features

- **Nicer Command Prompt**: Shows your username, computer name, current folder, and git branch
- **Smart History**: Doesn't save duplicates and shares history between terminal windows
- **Better Tab Completion**: Isn't fussy about capitals and shows options in a menu
- **Handy Shortcuts**: Quick commands for common tasks like checking git status
- **Pretty File Listings**: Uses `eza` instead of `ls` for colourful, feature-rich file lists
- **Works With Popular Add-ons**: Easy to use with other popular terminal tools
- **Helper Functions**: Little tools for common jobs like extracting archives
- **Theming Support**: Makes your file listings look nice with colour themes
- **Ultra Compatibility**: Works on any Mac setup without needing to change paths

## Setting It Up

### Basic Setup

1. **Back up your current setup**:
   ```bash
   cp ~/.zshrc ~/.zshrc.backup
   ```

2. **Grab this repo**:
   ```bash
   git clone https://github.com/yourusername/macOS-zshrc.git
   ```

3. **Copy the config file**:
   ```bash
   cp macOS-zshrc/.zshrc ~/.zshrc
   ```

4. **Install the recommended tools**:
   ```bash
   # Install the main tools
   brew install eza bat fzf autojump zsh-syntax-highlighting zsh-autosuggestions
   
   # Set up fzf shortcuts
   $(brew --prefix)/opt/fzf/install
   
   # Install a special font for icons
   brew tap homebrew/cask-fonts
   brew install --cask font-hack-nerd-font
   ```

5. **Set up pretty file listings** (optional):
   ```bash
   # Create a config folder
   mkdir -p ~/.config/eza
   
   # Get the themes
   git clone https://github.com/eza-community/eza-themes.git ~/.config/eza/eza-themes
   
   # Link to your chosen theme
   ln -sf ~/.config/eza/eza-themes/themes/default.yml ~/.config/eza/theme.yml
   ```

6. **Restart your terminal**:
   ```bash
   source ~/.zshrc
   ```

### Coming Soon

I'm working on a setup script that will do all this automatically for you.

## How It's Organised

After you set everything up, you'll have:

```
~
├── .zshrc                      # Your main config file
├── .zsh_history                # Where your command history is saved
└── .config
    └── eza                     # Settings for prettier file listings
        ├── theme.yml           # Link to your active theme
        └── eza-themes/         # Collection of available themes
            └── themes/         # Folder with all the themes
```

## What Each Bit Does

### Basic Settings

```bash
export LANG=en_US.UTF-8
export EDITOR="nano"  # Change to vim/emacs if you prefer
export HOMEBREW_AUTO_UPDATE_SECS="86400"  # Homebrew updates once a day
export EZA_THEME_PATH="$HOME/.config/eza/theme.yml"  # Where your eza theme is
```

- `LANG`: Sets your default language
- `EDITOR`: Which text editor to use
- `HOMEBREW_AUTO_UPDATE_SECS`: How often Homebrew checks for updates
- `EZA_THEME_PATH`: Where to find your colour theme for file listings

### Command History

```bash
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # Don't save duplicate commands
setopt HIST_IGNORE_SPACE      # Don't save commands that start with space
setopt HIST_VERIFY            # Show command before running it when using history
setopt SHARE_HISTORY          # Share history between all terminal windows
```

This makes your command history more useful by:
- Saving 10,000 commands
- Not cluttering history with duplicates
- Letting you hide commands from history (start with space)
- Showing what will run before running it
- Sharing history between all your terminal windows

### Folder Navigation

```bash
setopt AUTO_CD                # Type folder name to go to it
setopt AUTO_PUSHD             # Remember folders you've visited
setopt PUSHD_IGNORE_DUPS      # Don't remember the same folder twice
setopt PUSHD_SILENT           # Don't show the folder stack every time
```

This makes moving around folders easier:
- Just type the folder name to go there (no need for `cd`)
- Keeps track of where you've been
- Doesn't list duplicate folders
- Keeps things quiet when changing folders

### Tab Completion

```bash
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select                    # Menu-style completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Not fussy about capitals
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colourful completion
```

Makes tab completion better:
- Shows a menu of options you can navigate
- Doesn't care if you use capitals or lowercase
- Uses colours to make options easier to see

### Handy Shortcuts

```bash
# File navigation with eza (prettier ls replacement with icons)
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias la="eza -a --icons"
alias lt="eza --tree --icons"
alias l.="eza -d .* --icons"
alias l="eza -F --icons"
alias lh="eza -lah --icons"  # Human-readable sizes
alias lm="eza -la --sort=modified --icons"  # Sort by change time
alias lS="eza -la --sort=size --icons"  # Sort by file size

# Folder navigation
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
```

These shortcuts make common tasks faster:
- **File Tools**: Better versions of `ls` commands with colours and icons
- **Folder Shortcuts**: Quick ways to go up folder levels
- **Git Commands**: Short versions of common git tasks
- **System Commands**: Easy ways to edit and reload your terminal settings
- **Python Commands**: Shortcuts for Python stuff

### System Paths

```bash
# Homebrew - completely modular detection and setup
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  # Apple Silicon Mac (M1/M2/M3) standard location
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  # Intel Mac standard location
  eval "$(/usr/local/bin/brew shellenv)"
else
  # Fallback - try to find brew anywhere in PATH
  if command -v brew >/dev/null; then
    eval "$(brew shellenv)"
  fi
fi

# NVM and Anaconda use similarly smart detection
```

This setup makes sure your Mac can find all the necessary programs on any system:
- **Smart Homebrew detection**: Works with any Homebrew installation (Apple Silicon, Intel, or custom)
- **Flexible NVM configuration**: Finds Node.js version manager wherever it's installed
- **Adaptive Anaconda/Miniconda paths**: Supports multiple Python distribution locations
- **Plugin path flexibility**: Finds plugins regardless of how they were installed

### Extra Tools

```bash
# Uses a clever helper function to find plugins regardless of installation method
_source_plugin "zsh-syntax-highlighting" \
  "$(brew --prefix zsh-syntax-highlighting 2>/dev/null)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Similar approach for other plugins
```

Adds some really useful extras that work on any Mac:
- **Syntax Highlighting**: Makes commands colourful as you type
- **Auto-suggestions**: Shows grey text suggesting commands from history
- **fzf**: Fuzzy finder that makes searching history and files much easier
- **autojump/zoxide**: Remembers folders you use often so you can jump to them quickly

### Command Prompt

```bash
# Load colours and git info
autoload -Uz colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }

# Set up git info
zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f'
zstyle ':vcs_info:*' enable git

# Create a nice-looking prompt with username, computer, folder, and git branch
setopt PROMPT_SUBST
PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{yellow}%~%f ${vcs_info_msg_0_} %F{blue}❯%f '

# Show the time on the right
RPROMPT='%F{240}[%*]%f'
```

Gives you a helpful and pretty prompt that shows:
- Your username (in green)
- Your computer name (in purple)
- Current folder (in yellow)
- Git branch (in cyan) if you're in a git repo
- A blue arrow to type after
- The current time on the right side

### Useful Functions

```bash
# Make a folder and go to it
mcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract almost any archive file
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' can't be extracted by this function" ;;
        esac
    else
        echo "'$1' isn't a valid file"
    fi
}

# Quick find
qfind() {
    find . -name "$1" 2>&1 | grep -v 'Permission denied'
}

# Show all available colours
colors_demo() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour ${i}\n"
    done
}
```

Handy little tools to save you time:
- **mcd**: Makes a new folder and goes into it in one step
- **extract**: Opens any kind of archive file without remembering all the commands
- **qfind**: Finds files by name without the annoying permission errors
- **colors_demo**: Shows all the colours your terminal can display

## Making File Lists Pretty

This setup uses `eza` instead of the old `ls` command, which gives you much prettier file listings:

### Theme Support

You can use different colour themes for your file listings:

1. **Theme Location**: `~/.config/eza/theme.yml` (points to your current theme)
2. **Theme Collection**: `~/.config/eza/eza-themes` (has lots of themes to choose from)

### Changing Themes

To switch to a different theme:

```bash
# See what themes are available
ls -la ~/.config/eza/eza-themes/themes/

# Switch to a different theme
ln -sf ~/.config/eza/eza-themes/themes/new-theme.yml ~/.config/eza/theme.yml
```

### Getting Icons to Work

The file listing shortcuts (`ls`, `ll`, etc.) are set up to show icons. For these to work properly:

1. Install a special font that includes icons:
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-hack-nerd-font  # or another nerd font
   ```

2. Set your terminal to use this font (in your terminal preferences)

## Extra Tools Worth Adding

This setup works with several useful add-ons:

### Already Included

- **zsh-syntax-highlighting**: Makes commands colourful as you type
- **zsh-autosuggestions**: Suggests commands based on your history
- **fzf**: Fuzzy finder for searching files and history (press Ctrl+R to search history)
- **autojump/zoxide**: Smart folder navigation

### Other Good Ones to Try

- **bat**: A better `cat` with syntax highlighting
- **ripgrep**: Faster code searching
- **fd**: Simpler alternative to `find`
- **diff-so-fancy**: Nicer-looking git diffs
- **tmux**: Like having multiple terminal windows in one

## Mac-Specific Features

This setup has some special bits just for Mac:

### Homebrew Support

Works with Apple Silicon (M1/M2) and Intel Macs:
```bash
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"
```

### Mac Shortcuts

Handy commands for Mac stuff:
```bash
# Show/hide hidden files in Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"

# Clear DNS cache
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# Lock your screen
alias lock="osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down,control down}'"
```

### App Shortcuts

Quick ways to open Mac apps:
```bash
# Add these to open apps from terminal
alias safari="open -a Safari"
alias vscode="open -a 'Visual Studio Code'"
alias chrome="open -a 'Google Chrome'"
```

### Clipboard Helpers

Easy ways to copy and paste:
```bash
# Copy command output to clipboard
alias copy="pbcopy"
alias paste="pbpaste"
alias cpwd="pwd | tr -d '\n' | pbcopy"  # Copy current folder path
```

## Making It Your Own

### Changing the Prompt

To change how your prompt looks, edit the `PROMPT` and `RPROMPT` lines in `.zshrc`.

```bash
# A simpler prompt example
PROMPT='%F{blue}%~ %F{red}❯%f '

# A fancier prompt example
PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{yellow}%~%f ${vcs_info_msg_0_} 
%F{blue}λ%f '
```

### Adding Your Own Shortcuts

Add your own shortcuts in the "Aliases" section:

```bash
# Example custom shortcuts
alias myip="curl ifconfig.me"
alias weather="curl wttr.in"
alias cleanup="find . -type f -name '*.DS_Store' -delete"
```

### Adding Your Own Functions

Add custom functions in the "Functions" section:

```bash
# Example function to make a backup of a file
backup() {
    cp "$1" "$1.bak"
    echo "Made backup of $1"
}
```

## Fixing Common Problems

### Icons Not Showing Up

If you can't see the icons:
1. Check you've installed a Nerd Font: `brew list | grep font`
2. Make sure your terminal is using that font
3. Try running `eza --icons` directly to test
4. Consider using iTerm2 instead of Terminal.app

### Tool Not Working

If one of the extra tools isn't working:
1. Check if it's installed: `brew list | grep tool-name`
2. Make sure the path in your .zshrc matches your system
3. Try loading the tool manually to see any error messages

### Prompt Looks Wrong

If your prompt doesn't look right:
1. Check for typing errors in the PROMPT line
2. Make sure the git info is set up properly
3. Try a simpler prompt to narrow down the problem

## Compatibility

This setup works with any Mac configuration:

- **Any macOS version**: Works on Monterey (12.x), Ventura (13.x), Sonoma (14.x), and newer
- **Any Mac hardware**: Automatically adapts for Intel or Apple Silicon (M1/M2/M3)
- **Any installation method**: Finds your tools no matter how they were installed
- **Custom directories**: Respects your custom installation paths and preferences

You can use this .zshrc file as-is without tweaking paths for your specific setup - it will intelligently detect the right locations for everything.

## Works Well With Other Mac Tools

This setup plays nicely with other Mac customisation tools:

- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) for managing packages
- [defaults-write](https://github.com/kevinSuttle/macOS-Defaults) for system settings
- [iTerm2 profiles](https://iterm2.com/documentation-profiles.html) for terminal settings
- [Alfred](https://www.alfredapp.com/) or [Raycast](https://raycast.com/) for launching apps

For more Mac goodness, check out [awesome-mac](https://github.com/jaywcjlove/awesome-mac).

## Terminal Power Tips

- Use `Ctrl+R` to search your command history
- Use `Alt+C` to fuzzy-find folders to go to
- Type part of a folder name with autojump/zoxide: `j proj` to jump to ~/projects
- Use `extract archive.tar.gz` instead of remembering all those tar flags
- Create shortcuts for commands you use all the time

## Contributing

Got ideas to make this better? Please share!

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/my-cool-idea`
3. Make your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/my-cool-idea`
5. Send a pull request

## Licence

This project is licensed under the MIT Licence - see the LICENSE file for details.
