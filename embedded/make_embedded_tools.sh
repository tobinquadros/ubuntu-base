#!/usr/bin/env bash
# make_embedded_tools.sh

# Install kernel build dependencies if not already installed.
sudo apt-get install -y libncurses5-dev
sudo apt-get install -y gcc
sudo apt-get install -y gcc-doc
sudo apt-get install -y make
sudo apt-get install -y git
sudo apt-get install -y exuberant-ctags

# Install serial communication tools.
sudo apt-get install -y minicom
sudo apt-get install -y setserial

