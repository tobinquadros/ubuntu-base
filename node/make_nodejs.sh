#!/usr/bin/env bash
# Install or upgrade basic Node environment

# Install nodejs with Homebrew
brew install nodejs

# Configure npm, clear npm cache
ln -sf $HOME/dotfiles/node/.npmrc $HOME/.npmrc
npm cache clean

# Install or update bower, clear bower cache
npm install --global --quiet bower
bower cache clean

# Install or update express
npm install --global --quiet express

# Install or update grunt
npm install --global --quiet grunt
npm install --global --quiet grunt-cli

# Install or update jshint, configure globally
npm install --global --quiet jshint
ln -sf $HOME/dotfiles/node/.jshintrc $HOME/.jshintrc

# Install or update mathjs
npm install -g mathjs

npm config list
