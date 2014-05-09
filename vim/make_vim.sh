#!/usr/bin/env bash
# Install or upgrade Vim with .vimrc
# Install pathogen.vim and plugin bundles

# Install Vim and friends
sudo apt-get install -y vim
sudo apt-get install -y vim-gnome
sudo apt-get install -y cscope
sudo apt-get install -y exuberant-ctags

# Link vim directory to ~/.vim
ln -sfn $HOME/dotfiles/vim $HOME/.vim
ln -sf $HOME/dotfiles/vim/vimrc $HOME/.vimrc

# Create autoload directory and install current pathogen.vim.
mkdir -p "vim/autoload"
curl -LSso "vim/autoload/pathogen.vim" \
  "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"

# Create NEW bundle directory and install updated plug-in bundles.
rm -rf vim/bundle
mkdir -p vim/bundle
cd vim/bundle
echo "Installing updated Vim plug-ins..."
git clone https://github.com/scrooloose/syntastic.git
git clone https://github.com/majutsushi/tagbar.git
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/tpope/vim-markdown.git
git clone https://github.com/terryma/vim-multiple-cursors.git
git clone https://github.com/tpope/vim-repeat.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/tpope/vim-unimpaired.git
git clone https://github.com/benmills/vimux.git

# Change directory back to ~/dotfiles and continue install.sh
cd $HOME/dotfiles

