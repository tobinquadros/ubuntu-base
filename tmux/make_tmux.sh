#!/usr/bin/env bash
# TMUX install and configuration

# Install TMUX
sudo apt-get install -y tmux

# Configure TMUX settings
ln -sf $HOME/dotfiles/tmux/.Tmux.conf $HOME/.Tmux.conf
