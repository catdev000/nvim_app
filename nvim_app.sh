#!/bin/sh

main()
{
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
        install_brew_debian
        ;;
      Linux)
        install_brew_linux
        ;;
      *)
        echo "OS is not supported yet, please file an issue on Github: $OS"
        exit 1
        ;;
    esac
  fi

  brew install neovim
  nvim --version
  #nvim

}

install_brew_linux()
{
  echo "Linux detected, installing brew for linux"

}

install_brew_debian()
{
  echo "MacOS detected, installing brew for mac"

}

main
