#!/bin/sh

main()
{
  ## Start nvim if possible
  if which nvim > /dev/null; then
    nvim
    exit;
  fi

  echo "NeoVim is not installed, installing NeoVim..."

  ## Installing brew if not installed
  if which brew >/dev/null; then
    brew --version
  else
    echo "Brew required for installation, installing brew first"

    OS="$(uname -s)"

    case "$OS" in
      Darwin)
        install_brew_macos
        ;;
      Linux)
        install_brew_linux
        ;;
      *)
        echo "OS is not supported yet, please file an issue on Github: $OS"
        exit 1
        ;;
    esac
    source_brew
  fi
  
  install_nvim_custom_core

  if [ "$1" = '--pipeline' ]; then

    # Pipeline mode: start nvim and quit immmediatly
    nvim -c 'qa!'
    
    # Run tests if custom configs are there
    TARGET_PATH="$HOME/.config/nvim"

    if [ ! -d "$TARGET_PATH" ]; then
      echo "Error: Directory $TARGET_PATH not found"
      return 1
    fi

    if [ ! -f "$TARGET_PATH/init.lua" ]; then
      echo "Error: File $TARGET_PATH/init.lua not found"
      return 1
    fi

    if [ ! -f "$TARGET_PATH/lazy-lock.json" ]; then
      echo "Error: File $TARGET_PATH/lazy-lock.json not found"
      return 1
    fi

    if [ ! -d "$TARGET_PATH/lua" ]; then
      echo "Error: Directory $TARGET_PATH/lua not found"
      return 1
    fi

    echo "All pipeline checks passed."
    return 0
    exit;
  fi
  
  nvim
  exit;
}

install_brew_linux() {
  echo "Linux detected, installing brew for Linux"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
}

install_brew_macos() {
  echo "macOS detected, installing brew for mac"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/usr/local/bin:$PATH"
}

install_nvim_custom_core() {
  yes | brew install neovim
  nvim --version

  mkdir -p "$HOME/.config"
  
  NVIM_CORE_PATH="nvim_core"
  TARGET_PATH="$HOME/.config/nvim"

  if [ -d "$TARGET_PATH" ]; then
    echo "Removing existing config at $TARGET_PATH..."
    rm -rf "$TARGET_PATH"
  fi

  if [ -d "$NVIM_CORE_PATH" ]; then
    echo "Copy nvim_core to $TARGET_PATH..."
    cp -r "$NVIM_CORE_PATH" "$TARGET_PATH"
  else
    echo "Error: nvim_core folder not found in script directory ($SCRIPT_DIR)"
    return 1
  fi
}

source_brew() {
  if [ -f ~/.zshrc ]; then
    source ~/.zshrc
  elif [ -f ~/.bashrc ]; then
    source ~/.bashrc
  else
    echo "No .zshrc or .bashrc found. Please check your shell configuration."
  fi
}
 

main "$@"
