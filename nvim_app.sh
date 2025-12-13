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

  brew install neovim
  nvim --version

  if [ "$1" = "--pipeline" ]; then
    # Interactive mode: start nvim normally
    nvim
  else
    # Pipeline mode: start nvim and quit immediately
    nvim -c ':qa'
  fi
  
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

source_brew() {
  if [ -f ~/.zshrc ]; then
    source ~/.zshrc
  elif [ -f ~/.bashrc ]; then
    source ~/.bashrc
  else
    echo "No .zshrc or .bashrc found. Please check your shell configuration."
  fi
}
 

main
