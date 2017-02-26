#!/bin/bash

# Utils
function is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0;  }
  # return
  echo "$return_"
}

# Handle options
while test $# -gt 0; do 
  case "$1" in
    --help)
      echo "Help"
      exit
      ;;
  esac

  shift
done

# Install brew if any
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed brew)" == "0" ]; then
    echo "MacOS detected"
    echo "No Homebrew installed, getting Homebrew now"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

# Install zsh if any
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed zsh)" == "0" ]; then
    echo "MacOS detected"
    echo "No zsh installed, getting zsh now"
    if [ "$(is_installed brew)" == "1" ]; then
      brew install zsh zsh-completions
      echo "Install Oh My Zsh"
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
  fi
fi

# Backup if any
echo "Backing up dotfiles if any"
mv ~/.zshrc ~/.zshrc.bak
mv ~/.tmux.conf ~/.tmux.conf.bak
mv ~/.vim ~/.vim.bak
mv ~/.vimrc ~/.vimrc.bak
mv ~/.vimrc.bundles ~/.vimrc.bundles.bak

# Copy files
echo "Copying dotfiles"
cp zshrc ~/.zshrc
cp tmux.conf ~/.tmux.conf
mkdir ~/.vim
cp -R vim/* ~/.vim/
cp vimrc ~/.vimrc
cp vimrc.bundles ~/.vimrc.bundles

# Install ternjs for vim
if [ "$(is_installed npm)" == "1" ]; then
  echo "Install ternjs for autocomplete javascript in vim/nvim"
  npm install -g tern
fi

# Update formular for copying in vim
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed brew)" == "1" ]; then
    echo "Install brew formula reattach-to-user-namespace for copying in vim with tmux"
    brew install reattach-to-user-namespace
  fi
fi

# Install neovim
if [[ $OSTYPE == darwin* ]]; then
  if [ "$(is_installed nvim)" == "0" ]; then
    echo "MacOS detected"
    echo "No neovim installed, getting neovim now"
    if [ "$(is_installed brew)" == "1" ]; then
      brew install neovim/neovim/neovim
      # Install dotfiles for nvim
      echo "Copying file for neovim"
      mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
      ln -s ~/.vim $XDG_CONFIG_HOME/nvim
      ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
    fi
  fi
fi
