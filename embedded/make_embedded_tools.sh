#!/usr/bin/env bash
# make_kernel_tools.sh

# Install kernel build dependencies if not already installed.
sudo apt-get install libncurses5-dev gcc make git exuberant-ctags

# Install serial communication tools.
sudo apt-get install -y minicom

