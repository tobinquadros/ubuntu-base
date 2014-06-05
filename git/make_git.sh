#!/usr/bin/env bash
# Git install and configuration

# Install git
sudo apt-get install -y git
if [[ ! -z $(which X) ]]; then
  sudo apt-get install -y git-gui
fi

# Configure Git settings
ln -sf $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/dotfiles/git/.gitignore_global $HOME/.gitignore_global

