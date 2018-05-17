#!/usr/bin/env bash
set -e

# updates
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y \
  bcmwl-kernel-source \ # broadcom wifi adapters
  git # needed to clone https://github.com/tobinquadros/ubuntu-base.git
