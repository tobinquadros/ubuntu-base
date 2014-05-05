#!/usr/bin/env bash
# Git install and configuration

# Install git
sudo apt-get install -y git

# Configure Git settings
ln -sf git/.gitconfig $HOME/.gitconfig
ln -sf git/.gitignore_global $HOME/.gitignore_global

