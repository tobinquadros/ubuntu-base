#!/usr/bin/env bash
# Git install and configuration

# Install git from homebrew
brew install git

# Configure Git settings
ln -sf $HOME/dotfiles/git/.gitconfig $HOME/.gitconfig
ln -sf $HOME/dotfiles/git/.gitignore_global $HOME/.gitignore_global

# Install git
sudo apt-get install -y git
