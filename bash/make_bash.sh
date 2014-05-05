#!/usr/bin/env bash
# Install or upgrade basic Bash environment

# Install updated Bash from homebrew
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
