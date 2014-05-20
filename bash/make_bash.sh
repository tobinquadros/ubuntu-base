#!/usr/bin/env bash

# Install or upgrade the basic Bash environment
sudo apt-get install -y bash
sudo apt-get install -y bash-completion
sudo apt-get install -y bash-doc

# Configure bash environment
#ln -sf $HOME/dotfiles/bash/.bash_functions $HOME/.bash_functions
#ln -sf $HOME/dotfiles/bash/.bash_aliases $HOME/.bash_aliases
#ln -sf $HOME/dotfiles/bash/.bash_profile $HOME/.bash_profile
#ln -sf $HOME/dotfiles/bash/.bashrc $HOME/.bashrc

# Install other shell utilities
sudo apt-get install -y curl
sudo apt-get install -y tree

# TODO: Move these to a better place.
sudo apt-get install -y build-essential
sudo apt-get install -y grsync
sudo apt-get install -y gparted

