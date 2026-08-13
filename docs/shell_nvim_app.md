## How does nvim_app.sh works on your macOS or linuxOS

### Check if nvim exists as command (skip installation if it does and start nvim)
```
if which nvim > /dev/null; then
    nvim
    exit;
fi
```

### Check if brew ins installed (install it if not)
``` 
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
```

### Install nvim with brew
```
brew install neovim
nvim --version
```

### If pipeline mode is active start, test and close nvim again, otherwise start it normally
```
if [ "$1" = "--pipeline" ]; then
    # Interactive mode: start nvim normally
    nvim
else
    # Pipeline mode: start nvim and quit immediately
    nvim -c ':qa'
fi
```

### Helper functions for installation
```
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
```
