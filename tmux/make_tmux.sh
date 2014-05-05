#!/usr/bin/env bash
# TMUX install and configuration

# Install TMUX from homebrew
brew install tmux

# Configure TMUX settings
ln -sf $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
