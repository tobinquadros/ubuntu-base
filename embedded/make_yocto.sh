#!/usr/bin/env bash
# make_yocto.sh

# Essential and graphical support packages you need for a supported Ubuntu or
# Debian distribution to build an image that runs on QEMU in graphical mode.
sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
  build-essential chrpath libsdl1.2-dev xterm
